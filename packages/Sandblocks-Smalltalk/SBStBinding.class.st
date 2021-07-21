Class {
	#name : #SBStBinding,
	#superclass : #SBStNameBehavior,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStBinding class >> checkCastFor: aBlock parent: aMorph [
	" binding is the fallback: always return false to let the more specific classes try and match first "

	^ false
]

{ #category : #'as yet unclassified' }
SBStBinding >> argNameToType: aString [

	^ ((aString size > 3 and: [aString first = $a])
		ifTrue: [(aString second = $n ifTrue: [aString allButFirst: 2] ifFalse: [aString allButFirst]) asSymbol]
		ifFalse: [aString]) withFirstCharacterDownshifted
]

{ #category : #'as yet unclassified' }
SBStBinding >> browse [
	<action>

	self resolveBinding ifNotNil: #browse
]

{ #category : #'as yet unclassified' }
SBStBinding >> browseSenders [
	<action>

	self resolveBinding ifNotNil: [:binding | binding behavior browseReferences]
]

{ #category : #'as yet unclassified' }
SBStBinding >> contentsChanged [

	(self contents = 'true' or: [self contents = 'false'])
		ifTrue: [^ self block behavior: SBStBoolean new].
	
	self block isReserved
		ifTrue: [^ self block behavior: SBStKeywordBinding new]
]

{ #category : #'as yet unclassified' }
SBStBinding >> fixActions [

	^ self validBinding ifTrue: [#()] ifFalse: [
		{
			(self block containingBlock ifNotNil: [:b | b isMethodBody not] ifNil: [false])
				ifTrue: [
					SBCodeAction
						labeled: 'Declare block-local'
						for: self block
						do: [:node | node containingBlock declareTemporaryVariable: node contents]]
				ifFalse: [nil].
			SBCodeAction
				labeled: 'Declare method temporary'
				for: self block
				do: [:node | node containingArtefact body declareTemporaryVariable: node contents].
			SBCodeAction
				labeled: 'Declare instance variable'
				for: self block
				do: [:node | self declareInstanceVariable].
			self block containingArtefact isMethod
				ifTrue: [
					SBCodeAction labeled: 'Add method argument' for: self block do: [:node |
						node containingArtefact signature
							addArgument: (self argNameToType: node contents)
							block: node veryDeepCopy]]
				ifFalse: [nil]} select: #notNil]
]

{ #category : #'as yet unclassified' }
SBStBinding >> guessedClass [

	^ self resolveBinding ifNotNil: #guessedClass
]

{ #category : #'as yet unclassified' }
SBStBinding >> inputCommandClass [

	^ self resolveBinding ifNotNil: #inputCommandClass ifNil: [SBInputCommand]
]

{ #category : #'as yet unclassified' }
SBStBinding >> isBinding [

	^ true
]

{ #category : #'as yet unclassified' }
SBStBinding >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBStBinding >> printBlockOn: aStream [

	aStream nextPutAll: 'binding '.
	aStream nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStBinding >> resolveBinding [

	self block containingArtefact ifNotNil: [:artefact |
		self block binding: self contents for: self block class: artefact relatedClass ifPresent: [:b | ^ b]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBStBinding >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForBinding: self block
]

{ #category : #'as yet unclassified' }
SBStBinding >> useAsMessageSend [
	<action>

	^ self block sandblockEditor do: (SBReplaceCommand new
		target: self block;
		replacer: (SBStMessageSend new
			receiver: (SBStName contents: 'self')
			selector: self block contents asSymbol);
		yourself)
]

{ #category : #'as yet unclassified' }
SBStBinding >> valid [

	^ self validBinding
]

{ #category : #'as yet unclassified' }
SBStBinding >> validBinding [

	^ self resolveBinding notNil
]
