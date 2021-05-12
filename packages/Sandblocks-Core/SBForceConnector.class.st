Class {
	#name : #SBForceConnector,
	#superclass : #SBConnectorLine,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBForceConnector >> baseForce [
	
	^ 0.1 * (self to center - self from center) 
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
SBForceConnector >> connectorType [

	 ^ #none
]

{ #category : #'as yet unclassified' }
SBForceConnector >> forceFor: aMorph [
	
	^ (aMorph == self from) 
		ifTrue: [self baseForce] 
		ifFalse: [self baseForce negated]
]

{ #category : #'as yet unclassified' }
SBForceConnector >> mouseDown: anEvent [

	self to withDecorator: SBForceMoveDecorator do: [:decorator | decorator unregisterAdditionalForce: self].
	self from withDecorator: SBForceMoveDecorator do: [:decorator | decorator unregisterAdditionalForce: self].
	
	self abandon.
]
