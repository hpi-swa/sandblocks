Class {
	#name : #SBNumberInput,
	#superclass : #SBStringMorph,
	#instVars : [
		'max',
		'step',
		'min',
		'isDown',
		'lastMousePosition',
		'value',
		'onChange',
		'oldCursor'
	],
	#category : #'Sandblocks-Morphs'
}

{ #category : #accessing }
SBNumberInput >> externalValueUpdate: aNumber [

	self value: aNumber
]

{ #category : #initialization }
SBNumberInput >> initialize [

	super initialize.
	
	min := -100000.
	max := 100000.
	step := 1.
	isDown := false
]

{ #category : #'event handling' }
SBNumberInput >> keyStroke: anEvent [

	super keyStroke: anEvent.
	
	self valueWithConstraints: ([self contents asNumber] on: NumberParserError do: [self value]).
	self sendChange
]

{ #category : #accessing }
SBNumberInput >> max [

	^ max
]

{ #category : #accessing }
SBNumberInput >> max: aNumber [

	max := aNumber
]

{ #category : #accessing }
SBNumberInput >> min [

	^ min
]

{ #category : #accessing }
SBNumberInput >> min: aNumber [

	min := aNumber
]

{ #category : #'event handling' }
SBNumberInput >> mouseDown: anEvent [

	super mouseDown: anEvent.
	anEvent hand newMouseFocus: self.
	isDown := true.
	lastMousePosition := anEvent position.
	
	oldCursor := Cursor currentCursor.
	Cursor resizeLeft show
]

{ #category : #'event handling' }
SBNumberInput >> mouseMove: anEvent [

	| delta |
	isDown ifTrue: [
		delta := anEvent position - lastMousePosition.
		self valueWithConstraints: self value + delta x.
		lastMousePosition := anEvent position.
		self sendChange]
]

{ #category : #'event handling' }
SBNumberInput >> mouseUp: anEvent [

	super mouseUp: anEvent.
	isDown := false.
	oldCursor ifNotNil: #show
]

{ #category : #accessing }
SBNumberInput >> onChange: aBlock [

	onChange := aBlock
]

{ #category : #'event handling' }
SBNumberInput >> sendChange [

	onChange ifNotNil: [:c | c value: self value]
]

{ #category : #'stepping and presenter' }
SBNumberInput >> step [

	^ step
]

{ #category : #accessing }
SBNumberInput >> step: aNumber [

	step := aNumber
]

{ #category : #accessing }
SBNumberInput >> value [

	^ value
]

{ #category : #accessing }
SBNumberInput >> value: aNumber [

	value := aNumber.
	step := aNumber isInteger ifTrue: [1] ifFalse: [0.1].
	self contents: (aNumber isInteger ifTrue: [aNumber] ifFalse: [aNumber printShowingDecimalPlaces: 2]) asString
]

{ #category : #accessing }
SBNumberInput >> valueWithConstraints: aNumber [

	self value: (aNumber clampLow: self min high: self max)
]
