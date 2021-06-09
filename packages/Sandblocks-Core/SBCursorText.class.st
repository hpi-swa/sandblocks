Class {
	#name : #SBCursorText,
	#superclass : #SBCursorPosition,
	#instVars : [
		'block',
		'cursorIndex'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCursorText >> = aPosition [

	^ self class = aPosition class and: [self block = aPosition block]
]

{ #category : #'as yet unclassified' }
SBCursorText >> block [

	^ block
]

{ #category : #'as yet unclassified' }
SBCursorText >> block: aBlock [

	block := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorText >> bounds [

	^ self block bounds expandBy: 2
]

{ #category : #'as yet unclassified' }
SBCursorText >> color [

	^ self block colorPolicy selectionColorForBlock: (self block parentSandblock ifNil: [self block])
]

{ #category : #'as yet unclassified' }
SBCursorText >> cursorIndex [

	^ cursorIndex ifNil: [1]
]

{ #category : #'as yet unclassified' }
SBCursorText >> drawOn: aCanvas [

	aCanvas
		line: self bounds bottomLeft - (-1 @ 0)
		to: self bounds bottomRight - (1 @ 0)
		width: self block frameSize
		color: self color negated.
	aCanvas
		line: self bounds bottomLeft - (-1 @ 1)
		to: self bounds bottomRight - (1 @ 1)
		width: self block frameSize
		color: self color
]

{ #category : #'as yet unclassified' }
SBCursorText >> enter [

	self block sandblockEditor
		startInput: self block
		at: self cursorIndex
		replacingContents: false
]

{ #category : #'as yet unclassified' }
SBCursorText >> hash [

	^ self block hash
]

{ #category : #'as yet unclassified' }
SBCursorText >> horizontalOffsetInFloat [

	^ self block containingFloat
		ifNotNil: [:float | | reference |
			reference := self block currentTextMorph cursorPosition x.
			reference - float left]
		ifNil: [self block left]
]

{ #category : #'as yet unclassified' }
SBCursorText >> leave [

	self block currentTextMorph stopEditing
]

{ #category : #'as yet unclassified' }
SBCursorText >> mode [

	^ #input
]

{ #category : #'as yet unclassified' }
SBCursorText >> moveHorizontal: aNumber wordWise: aBoolean [

	self block currentTextMorph
		moveCursor: aNumber
		ifAtBound: [^ self adjacentPosition: aNumber in: self block sandblockEditor]
		wordWise: aBoolean.
	
	cursorIndex := self block currentTextMorph cursor
]

{ #category : #'as yet unclassified' }
SBCursorText >> pixelPosition: aPoint [

	cursorIndex := (self block currentTextMorph cursorIndexForPosition: aPoint) max: 1
]

{ #category : #'as yet unclassified' }
SBCursorText >> placeAtEnd: aBoolean [

	cursorIndex := aBoolean ifTrue: [self block currentTextMorph contents size + 1] ifFalse: [1]
]

{ #category : #'as yet unclassified' }
SBCursorText >> selectLarger [

	^ SBCursorSelect new block: self block
]

{ #category : #'as yet unclassified' }
SBCursorText >> selectSmaller [

	
]
