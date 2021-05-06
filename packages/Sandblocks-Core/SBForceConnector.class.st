Class {
	#name : #SBForceConnector,
	#superclass : #SBConnectorLine,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBForceConnector >> force [
	
	^ 0.01 * (self to center - self from center)
]

{ #category : #'as yet unclassified' }
SBForceConnector >> step [
	
	| forceToApply |
	
	forceToApply := self force.
	self from withDecorator: SBForceMoveDecorator do: [:decorator | decorator addForce: forceToApply].
	self to withDecorator: SBForceMoveDecorator do: [:decorator | decorator addForce: forceToApply negated]
]

{ #category : #'as yet unclassified' }
SBForceConnector >> stepTime [
	
	^ 25
]
