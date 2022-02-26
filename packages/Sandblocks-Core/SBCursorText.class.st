Class {
	#name : #SBCursorText,
	#superclass : #SBCursorPosition,
	#instVars : [
		'block',
		'cursorIndex',
		'currentCommand',
		'replacingContents'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCursorText >> = aPosition [

	^ self class = aPosition class and: [self block = aPosition block]
]

{ #category : #'as yet unclassified' }
SBCursorText >> applyCommandIn: anEditor [

	self block stopEditing: currentCommand.
	
	currentCommand hasChange
		ifTrue: [anEditor do: currentCommand]
		ifFalse: [anEditor history noMoreMerge]
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

	^ self block bounds expandBy: 2 @ (self block frameSize * 2)
]

{ #category : #'as yet unclassified' }
SBCursorText >> color [

	^ self block colorPolicy selectionColorForBlock: (self block parentSandblock ifNil: [self block])
]

{ #category : #'as yet unclassified' }
SBCursorText >> currentCommand [

	^ currentCommand
]

{ #category : #'as yet unclassified' }
SBCursorText >> currentCommand: aCommand [

	currentCommand := aCommand
]

{ #category : #'as yet unclassified' }
SBCursorText >> cursorIndex [

	^ cursorIndex ifNil: [1]
]

{ #category : #'as yet unclassified' }
SBCursorText >> cursorIndex: aNumber [

	cursorIndex := aNumber clampLow: 1 high: self block currentTextMorph contents size + 1
]

{ #category : #'as yet unclassified' }
SBCursorText >> drawOn: aCanvas in: aRectangle color: aColor [

	| stroke |
	stroke := self block frameSize.
	aCanvas
		line: aRectangle bottomLeft - (-1 @ stroke)
		to: aRectangle bottomRight - (1 @ stroke)
		width: stroke
		color: aColor negated.
	aCanvas
		line: aRectangle bottomLeft - (-1 @ (stroke * 2))
		to: aRectangle bottomRight - (1 @ (stroke * 2))
		width: stroke
		color: aColor
]

{ #category : #'as yet unclassified' }
SBCursorText >> enterWith: aCursor [

	replacingContents ifTrue: [self block currentTextMorph contents: ''].
	self block currentTextMorph moveCursorTo: self cursorIndex
]

{ #category : #'as yet unclassified' }
SBCursorText >> hasDifferentEffect: aCursor [

	^ (super hasDifferentEffect: aCursor) or: [self replacingContents ~= aCursor replacingContents]
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
SBCursorText >> initialize [

	super initialize.
	
	replacingContents := false.
	cursorIndex := 1
]

{ #category : #testing }
SBCursorText >> isText [

	^ true
]

{ #category : #'as yet unclassified' }
SBCursorText >> leaveIn: anEditor with: aCursor [

	self applyCommandIn: anEditor.
	self block currentTextMorph stopEditing
]

{ #category : #'as yet unclassified' }
SBCursorText >> maybeUpdateFor: aPosition [

	self cursorIndex: aPosition cursorIndex.
	self block currentTextMorph moveCursorTo: self cursorIndex
]

{ #category : #'as yet unclassified' }
SBCursorText >> minimalBounds [

	^ self block bounds
]

{ #category : #'as yet unclassified' }
SBCursorText >> mode [

	^ #input
]

{ #category : #'as yet unclassified' }
SBCursorText >> moveCursorDown: aCursor [

	self block currentTextMorph
		moveCursorVertically: 1
		ifAtBound: [super moveCursorDown: aCursor]
]

{ #category : #'as yet unclassified' }
SBCursorText >> moveCursorUp: aCursor [

	self block currentTextMorph
		moveCursorVertically: -1
		ifAtBound: [super moveCursorUp: aCursor]
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

	cursorIndex := aPoint
		ifNotNil: [(self block currentTextMorph cursorIndexForPosition: aPoint) max: 1]
		ifNil: [1]
]

{ #category : #'as yet unclassified' }
SBCursorText >> placeAtEnd: aBoolean [

	cursorIndex := aBoolean ifTrue: [self block currentTextMorph contents size + 1] ifFalse: [1]
]

{ #category : #'as yet unclassified' }
SBCursorText >> replaceSelected: aBlock [

	aBlock startInputCommand ifNotNil: [
		self block: aBlock.
		aBlock currentTextMorph moveCursorTo: 900000000]
]

{ #category : #'as yet unclassified' }
SBCursorText >> replacingContents [

	^ replacingContents
]

{ #category : #'as yet unclassified' }
SBCursorText >> replacingContents: aBoolean [

	replacingContents := aBoolean
]

{ #category : #'as yet unclassified' }
SBCursorText >> selectLarger [

	^ SBCursorSelect new block: self block
]

{ #category : #'as yet unclassified' }
SBCursorText >> selectSmaller [

	^ self copy placeAtEnd: true
]

{ #category : #'as yet unclassified' }
SBCursorText >> selectionBounds [

	^ self block bounds
]
