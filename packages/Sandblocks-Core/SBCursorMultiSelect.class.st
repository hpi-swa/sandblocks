Class {
	#name : #SBCursorMultiSelect,
	#superclass : #SBCursorPosition,
	#instVars : [
		'selected',
		'focused'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> = aPosition [

	^ aPosition class = self class and: [aPosition block = self block and: [aPosition selected hasEqualElements: self selected]]
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> add: aBlock [

	selected add: aBlock.
	aBlock attachDecorator: SBMultiSelectionDecorator new
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> block [

	^ focused
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> bounds [

	^ self block bounds expandBy: 4
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> drawOn: aCanvas in: aRectangle color: aColor [

	aCanvas
		frameRoundRect: (aRectangle insetBy: 2)
		radius: self block colorPolicy cornerRadius
		width: self block frameSize
		color: aColor
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> hash [

	^ self block hash bitXor: self selected hash
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> horizontalOffsetInFloat [

	^ self block containingFloat
		ifNotNil: [:float | | reference |
			reference := self bounds center x.
			reference - float left]
		ifNil: [self bounds center x]
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> initialize [

	super initialize.
	
	selected := OrderedCollection new
]

{ #category : #testing }
SBCursorMultiSelect >> isMultiSelect [

	^ true
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> leaveIn: anEditor with: aCursor [

	selected do: [:block | block detachDecorators: SBMultiSelectionDecorator]
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> minimalBounds [

	^ self block bounds
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> mode [

	^ #selection
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> moveHorizontal: aNumber wordWise: aBoolean [

	focused := (self adjacentPosition: aNumber to: (SBCursorSelect new block: self block) in: self block sandblockEditor that: [:s | s isKindOf: SBCursorSelect]) block.
	^ self
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> multiSelection [

	^ (self selected includes: self block) ifFalse: [self selected, {self block}] ifTrue: [self selected]
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> selectLarger [

	^ self block parentSandblock ifNotNil: [:parent | focused := parent. self] ifNil: [self]
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> selectSmaller [

	focused hasChildSandblocks ifFalse: [^ self].
	
	focused := focused childSandblocks first.
	^ self
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> selected [

	^ selected
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> selected: aCollection [

	aCollection allButLastDo: [:block | self add: block].
	self start: aCollection last
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> selectionBounds [

	^ self block bounds
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> start: aBlock [

	focused := aBlock.
	self add: aBlock
]

{ #category : #'as yet unclassified' }
SBCursorMultiSelect >> startOrAddToMultiSelection: aBlock [

	self add: aBlock
]
