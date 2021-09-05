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

	^ self adjacentPosition: aNumber to: self in: (self navigationRootIn: anEditor) that: [:s | " skip over selects unless that block would otherwise not get visited at all "
	(s isKindOf: SBCursorSelect) not or: [s block currentTextMorph isNil and: [s block hasChildSandblocks not]]]
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> adjacentPosition: aNumber to: aPosition in: anEditor that: aBlock [

	| takeNext last |
	takeNext := false.
	last := nil.
	self cursorPositionsIn: (self navigationRootIn: anEditor) do: [:pos |
		(takeNext and: [aBlock value: pos]) ifTrue: [^ pos].
		pos = aPosition ifTrue: [aNumber > 0 ifTrue: [takeNext := true] ifFalse: [^ last]].
		(aBlock value: pos) ifTrue: [last := pos]].
	
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

	^ self block colorPolicy selectionColorForBlock: (self block parentSandblock ifNil: [self block])
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> currentCommand [

	^ nil
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> cursorPositionsIn: aContainer [

	^ Array streamContents: [:stream | aContainer cursorPositionsDo: [:pos | stream nextPut: pos]]
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> cursorPositionsIn: aContainer do: aBlock [
	" enumerate all possible cursor positions recursively "

	aContainer cursorPositionsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> drawOn: aCanvas [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> enter [

	
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> hasDifferentEffect: aCursor [

	^ aCursor ~= self
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
SBCursorPosition >> leaveIn: anEditor [

	
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> maybeUpdateFor: aPosition [
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
SBCursorPosition >> multiSelection [

	^ {self block}
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> navigationRootIn: anEditor [

	^ self block containingFloat
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
SBCursorPosition >> selectionBounds [

	^ self bounds
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> startOrAddToMultiSelection: aBlock [

	^ SBCursorMultiSelect new start: aBlock
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [
]

{ #category : #'as yet unclassified' }
SBCursorPosition >> valid [

	^ self block notNil and: [self block isInWorld]
]
