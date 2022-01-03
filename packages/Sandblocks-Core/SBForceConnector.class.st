Class {
	#name : #SBForceConnector,
	#superclass : #SBConnectorLine,
	#instVars : [
		'forceScale'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBForceConnector class >> connect: anObject to: anotherObject forceScale: aNumber [

	^ self new connect: anObject to: anotherObject forceScale: aNumber
]

{ #category : #'as yet unclassified' }
SBForceConnector >> baseForce [

	^ self to class attractionStrengthMultiplier * self from class attractionStrengthMultiplier * (self to center - self from center) * self forceScale
]

{ #category : #'as yet unclassified' }
SBForceConnector >> color [

	 ^ self to foregroundColor
]

{ #category : #'as yet unclassified' }
SBForceConnector >> connect: aMorph to: anotherMorph [

	super connect: aMorph to: anotherMorph.
	
	aMorph
		withDecorator: SBForceMoveDecorator
		do: [:decorator | decorator registerAdditionalForce: self].
	anotherMorph
		withDecorator: SBForceMoveDecorator
		do: [:decorator | decorator registerAdditionalForce: self].
	
	self updateVisibility.
	
	aMorph when: #gotGroup send: #updateVisibility to: self.
	anotherMorph when: #gotGroup send: #updateVisibility to: self
]

{ #category : #'as yet unclassified' }
SBForceConnector >> connect: anObject to: anotherObject forceScale: aNumber [
	
	self connect: anObject to: anotherObject.
	self forceScale: aNumber
]

{ #category : #'as yet unclassified' }
SBForceConnector >> connectorType [

	 ^ #none
]

{ #category : #'as yet unclassified' }
SBForceConnector >> delete [

	self to
		withDecorator: SBForceMoveDecorator
		do: [:decorator | decorator unregisterAdditionalForce: self].
	self from
		withDecorator: SBForceMoveDecorator
		do: [:decorator | decorator unregisterAdditionalForce: self].

	super delete
]

{ #category : #'as yet unclassified' }
SBForceConnector >> deleteBlock [
	
	self abandon
]

{ #category : #'as yet unclassified' }
SBForceConnector >> forceFor: aMorph [
	
	^ aMorph = self from
		ifTrue: [self baseForce] 
		ifFalse: [self baseForce negated]
]

{ #category : #accessing }
SBForceConnector >> forceScale [

	^ forceScale
]

{ #category : #accessing }
SBForceConnector >> forceScale: anObject [

	forceScale := anObject.
]

{ #category : #'as yet unclassified' }
SBForceConnector >> handlesMouseDown: anEvent [
	
	^  self visible and: [super handlesMouseDown: anEvent]
]

{ #category : #'as yet unclassified' }
SBForceConnector >> initialize [

	super initialize.
	self forceScale: 1
]

{ #category : #'as yet unclassified' }
SBForceConnector >> lineWidth [
	
	^ ((3 * forceScale) max: 1) asInteger
]

{ #category : #'as yet unclassified' }
SBForceConnector >> morphicLayerNumber [

	^ 101
]

{ #category : #'as yet unclassified' }
SBForceConnector >> mouseDown: anEvent [

	self abandon
]

{ #category : #'as yet unclassified' }
SBForceConnector >> saveString [ 
	
	^ String streamContents: [:stream |
		stream
			nextPutAll: self className;
			nextPutAll: ' connect: '.
		self from printIdentityStringOn: stream.
		stream	nextPutAll: ' to: '.
		self to printIdentityStringOn: stream.
		stream
			nextPutAll: ' forceScale: ';
			nextPutAll: self forceScale asString.
		]
]

{ #category : #'as yet unclassified' }
SBForceConnector >> updateVisibility [

	| aGroup |
	aGroup := self from group.

	(aGroup = self to group and: [aGroup notNil])
		ifTrue: [self hide]
		ifFalse: [self show]
]
