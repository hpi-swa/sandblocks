Class {
	#name : #SBWaypointMoveDecorator,
	#superclass : #SBForceMoveDecorator,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBWaypointMoveDecorator >> createForceWith: otherBlock [

	(otherBlock isKindOf: SBWaypoint)
		ifTrue: [
			self morph toggleTarget: otherBlock.
			otherBlock toggleTarget: self morph]
		ifFalse: [super createForceWith: otherBlock]
]
