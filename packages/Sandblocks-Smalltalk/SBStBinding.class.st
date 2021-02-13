Class {
	#name : #SBStBinding,
	#superclass : #SBStNameBehavior,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStBinding >> browse [
	<action>

	self resolveBinding ifNotNil: #browse
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

	^ self validBinding
		ifTrue: [#()]
		ifFalse: [{
			SBCodeAction
				labeled: 'Declare method temporary' for: self block
				do: [:node | node containingArtefact body declareTemporaryVariable: node contents].
			SBCodeAction
				labeled: 'Declare block-local' for: self block
				do: [:node | node containingBlock declareTemporaryVariable: node contents].
			SBCodeAction
				labeled: 'Declare instance variable' for: self block
				do: [:node | node sandblockEditor declareInstanceVariable: node contents for: node containingArtefact methodClass].
		}]
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

	self block binding: self contents for: self block class: self block containingArtefact relatedClass ifPresent: [:b | ^ b].
	^ nil
]

{ #category : #'as yet unclassified' }
SBStBinding >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForBinding: self block
]

{ #category : #'as yet unclassified' }
SBStBinding >> useAsMessageSend [
	<action>

	^ self block sandblockEditor do: ((SBReplaceCommand newFor: self block containingArtefact)
		target: self block;
		replacer: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: self block contents asSymbol);
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