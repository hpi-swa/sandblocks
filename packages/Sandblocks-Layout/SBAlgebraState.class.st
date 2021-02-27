"
A SBAlgebraState is an immutable object storing the current state of the layouting process in an SBAlgebraLayout.
"
Class {
	#name : #SBAlgebraState,
	#superclass : #Object,
	#instVars : [
		'offset',
		'startX',
		'lineHeight',
		'containerBottomRight'
	],
	#category : #'Sandblocks-Layout'
}

{ #category : #'as yet unclassified' }
SBAlgebraState >> = aState [

	^ aState lineHeight = lineHeight and: [aState offset = offset and: [aState startX = startX and: [aState containerBottomRight = containerBottomRight]]]
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> basicContainerBottomRight: aPoint [

	containerBottomRight := aPoint
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> basicLineHeight: aNumber [

	lineHeight := aNumber
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> basicOffset: aNumber [

	offset := aNumber
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> basicStartX: aNumber [

	startX := aNumber
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> containerBottomRight [

	^ containerBottomRight
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> containerExtentFrom: anOldState [

	^ self containerBottomRight - anOldState offset
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> hash [

	^ (startX hash bitXor: offset hash) bitXor: (lineHeight hash bitXor: containerBottomRight hash)
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> initialize [

	startX := 0.
	lineHeight := 0.
	offset := 0 @ 0.
	containerBottomRight := 0
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> lineHeight [

	^ lineHeight
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> lineHeight: aNumber [

	^ self copy basicLineHeight: aNumber; yourself
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> nestedInset: anEdgeInsets do: aBlock [

	| topLeftState bottomRightState |
	topLeftState := self
		offset: self offset + anEdgeInsets topLeft
		lineHeight: 0
		startX: self offset x + anEdgeInsets left
		containerBottomRight: self offset + anEdgeInsets topLeft.
	
	bottomRightState := aBlock value: topLeftState.
	
	^ topLeftState
		offset: bottomRightState offset + anEdgeInsets bottomRight
		containerBottomRight: bottomRightState containerBottomRight + anEdgeInsets bottomRight
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> newLineWithGap: aBoolean [

	^ self
		offset: self startX @ (self offset y + self lineHeight + (aBoolean ifTrue: [SBAlgebraLayout gap] ifFalse: [0]))
		lineHeight: 0
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> offset [

	^ offset
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> offset: aNumber [

	^ self copy basicOffset: aNumber; yourself
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> offset: aPoint containerBottomRight: anotherPoint [

	^ self copy
		basicOffset: aPoint;
		basicContainerBottomRight: anotherPoint;
		yourself
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> offset: aPoint lineHeight: aNumber [

	^ self copy basicOffset: aPoint; basicLineHeight: aNumber; yourself
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> offset: aPoint lineHeight: aNumber containerBottomRight: anotherPoint [

	^ self copy
		basicOffset: aPoint;
		basicLineHeight: aNumber;
		basicContainerBottomRight: anotherPoint;
		yourself
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> offset: aPoint lineHeight: aNumber startX: anotherNumber containerBottomRight: anotherPoint [

	^ self copy
		basicOffset: aPoint;
		basicLineHeight: aNumber;
		basicStartX: anotherNumber;
		basicContainerBottomRight: anotherPoint;
		yourself
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> placeSized: aPoint [

	^ self copy
		basicOffset: self offset + (aPoint x @ 0);
		basicLineHeight: (self lineHeight max: aPoint y);
		basicContainerBottomRight: (self containerBottomRight max: self offset + aPoint);
		yourself
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> startX [

	^ startX
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> startX: aNumber [

	^ self copy basicStartX: aNumber; yourself
]
