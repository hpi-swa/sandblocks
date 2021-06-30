Class {
	#name : #SBWaypointMoveDecorator,
	#superclass : #SBForceMoveDecorator,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBWaypointMoveDecorator >> createForceWith: otherBlock [
	
	(otherBlock isKindOf: SBWaypoint)
		ifTrue: [
			self morph targets add: otherBlock.
			otherBlock targets add: self morph]
		ifFalse: [super createForceWith: otherBlock]
]
