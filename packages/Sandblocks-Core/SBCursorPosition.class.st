Class {
	#name : #SBCursorPosition,
	#superclass : #Object,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCursorPosition >> = aPosition [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> adjacentPosition: aNumber in: anEditor [

	| takeNext last |
	takeNext := false.
	last := nil.
	self cursorPositionsIn: anEditor do: [:pos |
		takeNext ifTrue: [^ pos].
		pos = self ifTrue: [aNumber > 0 ifTrue: [takeNext := true] ifFalse: [^ last]].
		last := pos].
	
	takeNext ifFalse: [^ self error: 'did not find node again'].
	^ nil
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> block [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> bounds [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> color [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> cursorPositionsIn: aContainer [

	^ Array streamContents: [:stream | self cursorPositionsIn: aContainer do: [:pos | stream nextPut: pos]]
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> cursorPositionsIn: aContainer do: aBlock [
	" enumerate all possible cursor positions recursively "

	aContainer isSandblock ifTrue: [self insertCursorIn: aContainer near: nil before: true do: aBlock].
	
	aContainer submorphsDo: [:morph |
		morph isSandblock ifTrue: [self insertCursorIn: aContainer containingSandblock near: morph before: true do: aBlock].
		
		(morph isTextMorph and: [morph containingSandblock currentTextMorph notNil]) ifTrue: [aBlock value: (SBCursorText new block: morph containingSandblock)].
		morph isSandblock ifTrue: [aBlock value: (SBCursorSelect new block: morph)].
		
		self cursorPositionsIn: morph do: aBlock.
		
		morph isSandblock ifTrue: [self insertCursorIn: aContainer containingSandblock near: morph before: false do: aBlock]].
	
	aContainer isSandblock ifTrue: [self insertCursorIn: aContainer near: nil before: false do: aBlock]
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> drawOn: aCanvas [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> enter [

	
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> hash [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> horizontalOffsetInFloat [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> insertCursorIn: aBlock near: anotherBlock before: aBoolean do: aClosure [

	^ (aBlock insertEmptyCommandRequestNear: anotherBlock before: aBoolean) ifNotNil: [:cmd |
		aClosure value: (SBCursorInsert new
			command: cmd;
			before: aBoolean;
			adjacent: anotherBlock;
			container: aBlock)]
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> leave [

	
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> mode [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> moveHorizontal: aNumber wordWise: aBoolean [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> placeAtEnd: aBoolean [

	
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> selectCursorFor: aBlock [

	^ SBCursorSelect new block: aBlock
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> selectLarger [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> selectSmaller [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> textCursorFor: aBlock [

	^ SBCursorText new block: aBlock
]
