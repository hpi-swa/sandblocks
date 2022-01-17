Class {
	#name : #SBStBoolean,
	#superclass : #SBStKeywordBinding,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStBoolean class >> checkCastFor: aBlock parent: aMorph [

	^ aBlock contents = 'true' or: [aBlock contents = 'false']
]

{ #category : #'as yet unclassified' }
SBStBoolean >> contentsChanged [

	(self contents = 'true' or: [self contents = 'false'])
		ifFalse: [^ self block behavior: (self block isReserved ifTrue: [SBStKeywordBinding] ifFalse: [SBStBinding new])]
]

{ #category : #'as yet unclassified' }
SBStBoolean >> doubleClick: anEvent [

	self toggle
]

{ #category : #'as yet unclassified' }
SBStBoolean >> guessedClass [

	^ self parsedContents class
]

{ #category : #'as yet unclassified' }
SBStBoolean >> isBooleanBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBStBoolean >> isLiteralBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBStBoolean >> parsedContents [

	^ self contents = 'true'
]

{ #category : #'as yet unclassified' }
SBStBoolean >> printBlockOn: aStream [

	aStream nextPutAll: 'boolean '.
	aStream nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStBoolean >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForBoolean: self block
]

{ #category : #'as yet unclassified' }
SBStBoolean >> toggle [
	<action>

	self block sandblockEditor do: (SBMutatePropertyCommand new
		target: self block;
		selector: #contents;
		value: self parsedContents not asString;
		yourself)
]

{ #category : #'as yet unclassified' }
SBStBoolean >> valid [

	^ true
]
