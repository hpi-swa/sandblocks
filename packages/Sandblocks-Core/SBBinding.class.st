Class {
	#name : #SBBinding,
	#superclass : #SBNameBehavior,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBinding >> browse [
	<action>

	self resolveBinding ifNotNil: #browse
]

{ #category : #'as yet unclassified' }
SBBinding >> contentsChanged [

	(self contents = 'true' or: [self contents = 'false'])
		ifTrue: [^ self block behavior: SBBoolean new].
	
	self block isReserved
		ifTrue: [^ self block behavior: SBKeywordBinding new]
]

{ #category : #'as yet unclassified' }
SBBinding >> fixActions [

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
SBBinding >> guessedClass [

	^ self resolveBinding ifNotNil: #guessedClass
]

{ #category : #'as yet unclassified' }
SBBinding >> inputCommandClass [

	^ self resolveBinding ifNotNil: #inputCommandClass ifNil: [SBInputCommand]
]

{ #category : #'as yet unclassified' }
SBBinding >> isBinding [

	^ true
]

{ #category : #'as yet unclassified' }
SBBinding >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBBinding >> printBlockOn: aStream [

	aStream nextPutAll: 'binding '.
	aStream nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBBinding >> resolveBinding [

	self block binding: self contents for: self block class: self block containingArtefact relatedClass ifPresent: [:b | ^ b].
	^ nil
]

{ #category : #'as yet unclassified' }
SBBinding >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForBinding: self block
]

{ #category : #'as yet unclassified' }
SBBinding >> useAsMessageSend [
	<action>

	^ self block sandblockEditor do: ((SBReplaceCommand newFor: self block containingArtefact)
		target: self block;
		replacer: (SBMessageSend new receiver: (SBName contents: 'self') selector: self block contents asSymbol);
		yourself)
]

{ #category : #'as yet unclassified' }
SBBinding >> valid [

	^ self validBinding
]

{ #category : #'as yet unclassified' }
SBBinding >> validBinding [

	^ self resolveBinding notNil
]
