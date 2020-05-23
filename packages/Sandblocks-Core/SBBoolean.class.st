Class {
	#name : #SBBoolean,
	#superclass : #SBKeywordBinding,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBoolean >> contentsChanged [

	(self contents = 'true' or: [self contents = 'false'])
		ifFalse: [^ self block behavior: (self block isReserved ifTrue: [SBKeywordBinding] ifFalse: [SBBinding new])]
]

{ #category : #'as yet unclassified' }
SBBoolean >> guessedClass [

	^ Boolean
]

{ #category : #'as yet unclassified' }
SBBoolean >> isBooleanBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBBoolean >> isLiteralBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBBoolean >> parsedContents [

	^ self contents = 'true'
]

{ #category : #'as yet unclassified' }
SBBoolean >> printBlockOn: aStream [

	aStream nextPutAll: 'boolean '.
	aStream nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBBoolean >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForBoolean: self block
]

{ #category : #'as yet unclassified' }
SBBoolean >> toggle [
	<action>

	self block sandblockEditor do: ((SBMutatePropertyCommand newFor: self block containingArtefact)
		target: self block;
		selector: #contents;
		value: self parsedContents not asString;
		yourself)
]

{ #category : #'as yet unclassified' }
SBBoolean >> valid [

	^ true
]
