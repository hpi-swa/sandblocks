Class {
	#name : #SBCursorSelect,
	#superclass : #SBCursorPosition,
	#instVars : [
		'block'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCursorSelect >> = aPosition [

	^ aPosition class = self class and: [aPosition block = self block]
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> block [

	^ block
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> block: aBlock [

	block := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> bounds [

	^ self block bounds expandBy: 4
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> color [

	^ self block colorPolicy selectionColorForBlock: (self block parentSandblock ifNil: [self block])
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> drawOn: aCanvas [

	aCanvas
		frameRoundRect: (self bounds insetBy: 2)
		radius: self block colorPolicy cornerRadius
		width: self block frameSize
		color: self color
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> hash [

	^ self block hash
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> horizontalOffsetInFloat [

	^ self block containingFloat
		ifNotNil: [:float | | reference |
			reference := self bounds center x.
			reference - float left]
		ifNil: [self bounds center x]
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> mode [

	^ #command
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> moveHorizontal: aNumber wordWise: aBoolean [

	^ self adjacentPosition: aNumber in: self block sandblockEditor
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> selectLarger [

	^ SBCursorSelect new block: self block parentSandblock
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> selectSmaller [

	self block childSandblocks ifEmpty: [
		self block currentTextMorph ifNotNil: [^ self textCursorFor: self block].
		self insertCursorIn: self block near: nil before: false do: [:cursor | ^ cursor].
		^ self].
	
	^ self selectCursorFor: self block childSandblocks first
]
