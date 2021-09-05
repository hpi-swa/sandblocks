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
SBCursorSelect >> drawOn: aCanvas in: aRectangle [

	aCanvas
		frameRoundRect: (aRectangle insetBy: 2)
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

	aNumber > 0 ifTrue: [ | next |
		" to make addressing inserts in empty blocks easier, go in if possible "
		self block hasChildSandblocks ifFalse: [self cursorPositionsIn: self block do: [:position | position = self ifFalse: [^ position]]].
		
		next := self
			adjacentPosition: aNumber
			to: self
			in: self block sandblockEditor
			that: [:p | ((p block hasOwner: self block) or: [p block = self block]) not and: [(p isKindOf: SBCursorSelect) not or: [p block currentTextMorph isNil and: [p block hasChildSandblocks not]]]].
		
		^ next ifNil: [" if we are past all positions, see if we want to enter this block instead "
		self cursorPositionsIn: self block do: [:position | position = self ifFalse: [^ position]]]].
	^ self adjacentPosition: aNumber in: self block sandblockEditor
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> selectLarger [

	^ self block parentSandblock ifNotNil: [:parent | SBCursorSelect new block: parent] ifNil: [self]
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> selectSmaller [

	self block childSandblocks ifEmpty: [
		self block startInputCommand ifNotNil: [:command |
			^ SBCursorText new
				block: self block;
				currentCommand: command;
				placeAtEnd: true].
		self cursorPositionsIn: self block do: [:position | position ~= self ifTrue: [^ position]].
		^ self].
	
	^ self selectCursorFor: self block childSandblocks first
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> selectionBounds [

	^ self block bounds
]

{ #category : #'as yet unclassified' }
SBCursorSelect >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [

	(self block grammarHandler ifNotNil: [:h | h characterCanStartInput: anEvent keyCharacter] ifNil: [false]) ifTrue: [
			self block grammarHandler startOverrideInput: anEvent in: anEditor.
			aBlock value]
]
