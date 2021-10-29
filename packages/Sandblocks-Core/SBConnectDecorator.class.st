Class {
	#name : #SBConnectDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'isMouseClose',
		'connectors',
		'connectionPoints'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #accessing }
SBConnectDecorator >> addConnectorFrom: sourceMorph to: destinationMorph [
	self connectors add: (SBConnectorLine connect: sourceMorph to: destinationMorph)
]

{ #category : #'as yet unclassified' }
SBConnectDecorator >> checkIsMouseNearby [

	^ (self morph boundsInWorld vectorToPoint: ActiveHand position) r < 10
]

{ #category : #accessing }
SBConnectDecorator >> connectionPoints [

	connectionPoints ifNil: [self initializeConnectionPoints].	
	^ connectionPoints
]

{ #category : #accessing }
SBConnectDecorator >> connectionPoints: anObject [
	connectionPoints := anObject
]

{ #category : #accessing }
SBConnectDecorator >> connectors [
	^ connectors
]

{ #category : #accessing }
SBConnectDecorator >> connectors: anObject [
	connectors := anObject
]

{ #category : #'as yet unclassified' }
SBConnectDecorator >> example [

	SBMorphExample
		setUp: [SBStPlayground new attachDecorator: self class new]
		cases: {SBMorphExampleCase name: 'example 1' caseBlock: [:m | m. m owner addMorph: m copy]}
		extent: 300 @ 300
]

{ #category : #'initialize-release' }
SBConnectDecorator >> initialize [

	super initialize.
	self 
		isMouseClose: false;
		connectors: Set new
]

{ #category : #'initialize-release' }
SBConnectDecorator >> initializeConnectionPoints [

	self connectionPoints: (Array streamContents: [:stream | 4 timesRepeat: [stream nextPut:( CircleMorph new extent: 4@4; yourself)]]).
	self connectionPoints do: [:morph | self morph owner addMorph: morph]
]

{ #category : #'as yet unclassified' }
SBConnectDecorator >> isMouseClose [

	^ isMouseClose
]

{ #category : #'as yet unclassified' }
SBConnectDecorator >> isMouseClose: aBoolean [

	isMouseClose := aBoolean
]

{ #category : #'initialize-release' }
SBConnectDecorator >> positionConnectionPoints [

	self connectionPoints first center: self morph bounds topCenter.
	self connectionPoints second center: self morph bounds rightCenter.
	self connectionPoints third center: self morph bounds bottomCenter.
	self connectionPoints fourth center: self morph bounds leftCenter
]

{ #category : #drawing }
SBConnectDecorator >> postDrawOn: aCanvas [

	self isMouseClose ifTrue: [aCanvas frameRectangle: self morph bounds color: Color red].
	super postDrawOn: aCanvas
]

{ #category : #stepping }
SBConnectDecorator >> step [

	| newIsMouseClose |
	newIsMouseClose := self checkIsMouseNearby.
	newIsMouseClose ~= self isMouseClose ifTrue: [
		self morph changed.
		self isMouseClose: newIsMouseClose].
	self connectionPoints do: [:connectionPoint | connectionPoint visible: newIsMouseClose].
	self positionConnectionPoints
]

{ #category : #stepping }
SBConnectDecorator >> stepTime [

	^ 250
]
