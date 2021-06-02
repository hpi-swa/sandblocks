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

	^ 0.05 * (self to center - self from center) * self forceScale
]

{ #category : #'as yet unclassified' }
SBForceConnector >> color [

	 ^ self to foregroundColor
]

{ #category : #'as yet unclassified' }
SBForceConnector >> connect: aMorph to: anotherMorph [

	super connect: aMorph to: anotherMorph.
	
	aMorph withDecorator: SBForceMoveDecorator do: [:decorator | decorator registerAdditionalForce: self].
	anotherMorph withDecorator: SBForceMoveDecorator do: [:decorator | decorator registerAdditionalForce: self]
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
SBForceConnector >> initialize [ 
	
	super initialize.
	self forceScale: 1
]

{ #category : #'as yet unclassified' }
SBForceConnector >> lineWidth [
	
	^ ((3 * forceScale) max: 1) asInteger
]

{ #category : #'as yet unclassified' }
SBForceConnector >> mouseDown: anEvent [

	self to withDecorator: SBForceMoveDecorator do: [:decorator | decorator unregisterAdditionalForce: self].
	self from withDecorator: SBForceMoveDecorator do: [:decorator | decorator unregisterAdditionalForce: self].
	
	self abandon.
]

{ #category : #'as yet unclassified' }
SBForceConnector >> saveString [ 
	
	^ String streamContents: [:stream |
		stream
			nextPutAll: self className;
			nextPutAll: ' connect: ';
			nextPutAll:	self from className;
			print:	self from identityHash;
			nextPutAll: ' to: ';
			nextPutAll:	self to className;
			print:	self to identityHash;
			nextPutAll: ' forceScale: ';
			nextPutAll: self forceScale asString.
		]
]
