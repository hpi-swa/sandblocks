Class {
	#name : #SBCursorInsert,
	#superclass : #SBCursorPosition,
	#instVars : [
		'command',
		'before',
		'adjacent',
		'container'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCursorInsert >> = aPosition [

	^ aPosition class = self class and: [aPosition adjacent = self adjacent and: [aPosition before = self before and: [aPosition container = self container]]]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> adjacent [

	^ adjacent
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> adjacent: aBlock [

	adjacent := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> before [

	^ before
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> before: aBoolean [

	before := aBoolean
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> block [

	^ self container
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> bounds [

	^ self container hasHorizontalLayout
		ifTrue: [
			self adjacent
				ifNil: [ | extra |
					extra := self container spaceForSymbols.
					self before
						ifTrue: [self container topLeft + (extra first @ 0) extent: self lineWidth @ self container height]
						ifFalse: [self container topRight - (self lineWidth + extra second @ 0) extent: self lineWidth @ self container height]]
				ifNotNil: [
					self before
						ifTrue: [self adjacent topLeft - (self lineWidth @ 0) extent: self lineWidth @ self adjacent height]
						ifFalse: [self adjacent topRight extent: self lineWidth @ self adjacent height]]]
		ifFalse: [
			self adjacent
				ifNil: [
					self before
						ifTrue: [self container topLeft extent: self container width @ self lineWidth]
						ifFalse: [self container bottomLeft - (self lineWidth @ 0) extent: self container width @ self lineWidth]]
				ifNotNil: [
					self before
						ifTrue: [self adjacent topLeft - (self lineWidth @ 0) extent: self adjacent width @ self lineWidth]
						ifFalse: [self adjacent bottomLeft extent: self adjacent width @ self lineWidth]]]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> color [

	^ self container colorPolicy selectionColorForBlock: (self container parentSandblock ifNil: [self container])
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> command [

	^ command
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> command: aBlock [

	command := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> container [

	^ container
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> container: aBlock [

	container := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> drawOn: aCanvas [

	aCanvas fillRectangle: self bounds color: self color
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> enter [

	super enter.
	self triggerEvent: #showLabel with: 'insert in ', self block printString
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> hash [

	^ self adjacent hash bitXor: (self before hash bitXor: self container hash)
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> horizontalOffsetInFloat [

	^ self block containingFloat
		ifNotNil: [:float | | reference |
			reference := self bounds center x.
			reference - float left]
		ifNil: [self bounds center x]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> leaveIn: anEditor [

	self triggerEvent: #showLabel with: nil
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> lineWidth [

	^ 3
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> mode [

	^ #insert
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> moveHorizontal: aNumber wordWise: aBoolean [

	| next |
	next := self adjacentPosition: aNumber in: self container sandblockEditor.
	^ (next class = self class and: [next command hasSamePositionAs: self command])
		ifTrue: [next adjacentPosition: aNumber in: self container sandblockEditor]
		ifFalse: [next]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> selectLarger [

	^ SBCursorSelect new block: self container
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> selectSmaller [

	
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [

	anEditor do: (self block insertEmptyCommandRequestNear: self adjacent before: self before).
	anEditor selection inputContainedUnknown.
	anEditor selection keyStroke: anEvent.
	aBlock value
]
