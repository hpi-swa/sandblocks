Class {
	#name : #SBConnectDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'isMouseClose'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBConnectDecorator >> checkIsMouseNearby [

	^ (self morph boundsInWorld vectorToPoint: ActiveHand position) r < 10
]

{ #category : #'as yet unclassified' }
SBConnectDecorator >> example [

	SBMorphExample
		setUp: [SBStPlayground new attachDecorator: self class new]
		cases: {SBMorphExampleCase name: 'example 1' caseBlock: [:m | m]}
		extent: 300 @ 300
]

{ #category : #'as yet unclassified' }
SBConnectDecorator >> initialize [

	super initialize.
	self isMouseClose: false
]

{ #category : #'as yet unclassified' }
SBConnectDecorator >> isMouseClose [

	^ isMouseClose
]

{ #category : #'as yet unclassified' }
SBConnectDecorator >> isMouseClose: aBoolean [

	isMouseClose := aBoolean
]

{ #category : #'as yet unclassified' }
SBConnectDecorator >> postDrawOn: aCanvas [

	super postDrawOn: aCanvas.
	self isMouseClose ifTrue: [aCanvas fillRectangle: self morph bounds color: Color red]
]

{ #category : #'as yet unclassified' }
SBConnectDecorator >> step [

	| newIsMouseClose |
	newIsMouseClose := self checkIsMouseNearby.
	newIsMouseClose ~= self isMouseClose ifTrue: [
		self morph changed.
		self isMouseClose: newIsMouseClose]
]

{ #category : #'as yet unclassified' }
SBConnectDecorator >> stepTime [

	^ 250
]
