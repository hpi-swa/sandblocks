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
		'containerWidth'
	],
	#category : #'Sandblocks-Layout'
}

{ #category : #'as yet unclassified' }
SBAlgebraState >> basicContainerWidth: aNumber [

	containerWidth := aNumber
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
SBAlgebraState >> containerWidth [

	^ containerWidth
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> containerWidth: aNumber [

	^ self copy basicContainerWidth: aNumber
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> extentFrom: anOldState [

	^ ((self offset x max: self containerWidth) @ self offset y) - anOldState offset + (0 @ self lineHeight)
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> initialize [

	startX := 0.
	lineHeight := 0.
	offset := 0 @ 0.
	containerWidth := 0
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> lineHeight [

	^ lineHeight
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> lineHeight: aNumber [

	^ self copy basicLineHeight: aNumber
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> offset [

	^ offset
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> offset: aNumber [

	^ self copy basicOffset: aNumber
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> offset: aPoint lineHeight: aNumber [

	^ self copy basicOffset: aPoint; basicLineHeight: aNumber; yourself
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> startX [

	^ startX
]

{ #category : #'as yet unclassified' }
SBAlgebraState >> startX: aNumber [

	^ self copy basicStartX: aNumber
]
