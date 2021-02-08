"
A SBTracingSimulator will execute a Smalltalk block and record all relevant sideeffects.

We distinguish between relevant and non-relevant sideeffects by tracking the identity of all objects that are created during the simulation.
These objects we consider as temporary objects.
When state is changed (meaning a variable changed was assigned a new value or a store into an object happened via `at:put:`), we see if this concerned one of the temporary objects.
If that is not the case, we consider the change as a relevant sideeffect (meaning persistent after execution of the sideeffect handler finished).
"
Class {
	#name : #SBStTracingSimulator,
	#superclass : #SBStSimulator,
	#instVars : [
		'tempObjects',
		'sideEffects'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'initialize-release' }
SBStTracingSimulator >> initialize [

	super initialize.
	
	sideEffects := OrderedCollection new.
	tempObjects := IdentitySet new
]

{ #category : #helper }
SBStTracingSimulator >> relevantFramesFrom: aContext [

	| ctx |
	ctx := aContext.
	self flag: #todo. " domain-tied to AEs "
	
	" go up until we find the AE's invocation "
	^ Array streamContents: [:stream |
		[ctx notNil and: [ctx selector ~= #invokeCallback:oldValue:newValue:]] whileTrue: [
			stream nextPut: (SBStCodeContext forPreviousOf: ctx).
			ctx := ctx sender]]
]

{ #category : #helper }
SBStTracingSimulator >> reportSideEffectTo: anObject named: aString value: anotherString [

	sideEffects add: {
		aString.
		anObject.
		anotherString.
		self relevantFramesFrom: currentContext}
]

{ #category : #'instruction decoding' }
SBStTracingSimulator >> send: selector super: supered numArgs: numArgs [

	| res |
	(selector == #addInvocation:value:from:expression: or: [selector == #halt or: [selector == #notify:instVarNamed:ofObject:changedFrom:to:inContext:]]) ifTrue: [
		res := (super send: selector super: supered numArgs: numArgs) runUntilErrorOrReturnFrom: currentContext.
		^ res first].
	(selector == #at:put: or: [selector == #new:]) ifTrue: [ | lookupClass receiver |
		receiver := currentContext at: currentContext stackPtr - numArgs.
		lookupClass := supered
			ifTrue: [currentContext method methodClassAssociation value superclass]
			ifFalse: [currentContext objectClass: receiver].
		(lookupClass lookupSelector: selector) ifNotNil: [:method | 
			method primitive = 71 ifTrue: [
				res := super send: selector super: supered numArgs: numArgs.
				tempObjects add: res top.
				^ res].
			(method primitive = 61 and: [(tempObjects includes: receiver) not]) ifTrue: [
				self
					reportSideEffectTo: receiver
					named: 'at: ', (currentContext at: currentContext stackPtr - 1)
					value: (currentContext at: currentContext stackPtr) asString]]].
	res := super send: selector super: supered numArgs: numArgs.
	(selector == #basicNew or: [selector == #basicNew:]) ifTrue: [tempObjects add: res top].
	^ res
]

{ #category : #accessing }
SBStTracingSimulator >> sideEffects [

	^ sideEffects
]

{ #category : #helper }
SBStTracingSimulator >> trackInstanceVarChange: offset [

	(tempObjects includes: currentContext receiver) ifFalse: [
		self
			reportSideEffectTo: currentContext receiver
			named: (currentContext receiver class instVarNameForIndex: offset + 1)
			value: currentContext top asString]
]
