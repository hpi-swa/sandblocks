"
A SBSynchronousActiveExpression is a subclass of SynchronousActiveExpression that supports some meta information about the active expression. It will also invoke its sideeffect handlers through the SBTracingSimulator to collect all relevant sideeffects.
"
Class {
	#name : #SBSynchronousActiveExpression,
	#superclass : #SynchronousActiveExpression,
	#instVars : [
		'lastSideEffects',
		'afterInvoke'
	],
	#category : #'Sandblocks-ActiveExpression'
}

{ #category : #callbacks }
SBSynchronousActiveExpression >> afterInvokeDo: aBlock [

	afterInvoke := aBlock
]

{ #category : #callbacks }
SBSynchronousActiveExpression >> invokeCallback: aBlock oldValue: old newValue: new [

	| tracer res |
	tracer := SBTracingSimulator new.
	
	aBlock argumentCount > 2 ifTrue: [self error: 'Callback requires too many arguments'].
	
	res := nil.
	tracer simulate: [
		aBlock argumentCount = 0 ifTrue: [res := aBlock value].
		aBlock argumentCount = 1 ifTrue: [res := aBlock valueWithArguments: {new}].
		aBlock argumentCount = 2 ifTrue: [res := aBlock valueWithArguments: {old. new}]].
	
	lastSideEffects := lastSideEffects, tracer sideEffects.
	
	^ res
]

{ #category : #accessing }
SBSynchronousActiveExpression >> lastSideEffects [

	^ lastSideEffects
]

{ #category : #change }
SBSynchronousActiveExpression >> propagateChangeFrom: oldValue to: newValue [

	self callbacksEnabled ifTrue: [ | invocation |
		lastSideEffects := {}.
		
		invocation := afterInvoke ifNotNil: [:b | b value: newValue value: self lastSideEffects].
		
		self callbacks do: [:each |
			self invokeCallback: each oldValue: oldValue newValue: newValue].
		
		invocation ifNotNil:[:i | i lastSideEffects: lastSideEffects]]
]

{ #category : #accessing }
SBSynchronousActiveExpression >> subject [

	^ subject
]

{ #category : #accessing }
SBSynchronousActiveExpression >> subject: anObject [

	subject := anObject
]
