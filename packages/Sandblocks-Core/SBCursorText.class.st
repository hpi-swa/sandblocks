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

	^ self class = aPosition class and: [self block = aPosition block and: [self currentCommand textMorph = aPosition currentCommand textMorph]]
]

{ #category : #'as yet unclassified' }
SBCursorText >> applyCommandIn: anEditor [

	self block stopEditing: currentCommand.
	
	currentCommand hasChange
		ifTrue: [
			" applying a command will cause a cursor change, however we are in the middle of a cursor change so prohibit any changes here "
			currentCommand selectAfter: #none.
			anEditor do: currentCommand]
		ifFalse: [SBToggledCode comment: '' active: 0 do: {[anEditor history noMoreMerge]}]
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

	^ self textMorph bounds expandBy: 2 @ (self block frameSize * 2)
]

{ #category : #'as yet unclassified' }
SBCursorText >> color [

	^ self block colorPolicy selectionColorForBlock: (self block parentSandblock ifNil: [self block])
]

{ #category : #'as yet unclassified' }
SBCursorText >> command [

	^ self currentCommand
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

	cursorIndex := aNumber clampLow: 1 high: self textMorph contents size + 1
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

	replacingContents ifTrue: [self textMorph contents: ''].
	self textMorph moveCursorTo: self cursorIndex.
	self textMorph containingSandblock selectedTextMorph: self textMorph
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
			reference := self textMorph cursorPosition x.
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
SBCursorText >> isJumpPoint [

	^ self command isJumpPoint
]

{ #category : #testing }
SBCursorText >> isText [

	^ true
]

{ #category : #'as yet unclassified' }
SBCursorText >> leaveIn: anEditor with: aCursor for: aNewPosition [

	self applyCommandIn: anEditor.
	self textMorph stopEditing.
	self textMorph containingSandblock deselectedTextMorph: self textMorph for: aNewPosition cursor: aCursor
]

{ #category : #'as yet unclassified' }
SBCursorText >> maybeUpdateFor: aPosition [

	self cursorIndex: aPosition cursorIndex.
	self textMorph moveCursorTo: self cursorIndex
]

{ #category : #'as yet unclassified' }
SBCursorText >> minimalBounds [

	^ self textMorph bounds
]

{ #category : #'as yet unclassified' }
SBCursorText >> mode [

	^ #input
]

{ #category : #'as yet unclassified' }
SBCursorText >> morph [

	^ self textMorph
]

{ #category : #'as yet unclassified' }
SBCursorText >> moveCursorDown: aCursor [

	self textMorph moveCursorVertically: 1 ifAtBound: [super moveCursorDown: aCursor]
]

{ #category : #'as yet unclassified' }
SBCursorText >> moveCursorUp: aCursor [

	self textMorph moveCursorVertically: -1 ifAtBound: [super moveCursorUp: aCursor]
]

{ #category : #'as yet unclassified' }
SBCursorText >> moveHorizontal: aNumber wordWise: aBoolean [

	self textMorph
		moveCursor: aNumber
		ifAtBound: [^ self adjacentPosition: aNumber in: self block sandblockEditor]
		wordWise: aBoolean.
	
	cursorIndex := self textMorph cursor
]

{ #category : #'as yet unclassified' }
SBCursorText >> pixelPosition: aPoint [

	cursorIndex := aPoint
		ifNotNil: [(self textMorph cursorIndexForPosition: aPoint) max: 1]
		ifNil: [1]
]

{ #category : #'as yet unclassified' }
SBCursorText >> placeAtEnd: aBoolean [

	cursorIndex := aBoolean ifTrue: [self textMorph contents size + 1] ifFalse: [1]
]

{ #category : #'as yet unclassified' }
SBCursorText >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	aStream print: self textMorph.
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBCursorText >> replaceSelected: aBlock [

	aBlock startInputCommand ifNotNil: [:command |
		currentCommand ifNotNil: [
			command
				newMorph: command oldMorph;
				oldMorph: currentCommand oldMorph;
				previousText: currentCommand previousText].
		currentCommand := command.
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

	^ self textMorph bounds
]

{ #category : #'as yet unclassified' }
SBCursorText >> textMorph [

	^ currentCommand textMorph
]
