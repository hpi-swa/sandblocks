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

{ #category : #'as yet unclassified' }
SBWaypointMoveDecorator >> noteNewOwner: aMorph [

	| potentialGroup |	
	super noteNewOwner: aMorph.
	potentialGroup := self
		morphAtPoint: self morph position
		satisfying: [:checkedMorph | checkedMorph isKindOf: SBGroup].
	potentialGroup ifNotNil: [potentialGroup add: self].
	idealPosition := nil
]
