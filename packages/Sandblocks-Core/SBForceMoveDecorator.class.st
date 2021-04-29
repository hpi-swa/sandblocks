Class {
	#name : #SBForceMoveDecorator,
	#superclass : #SBMoveDecorator,
	#instVars : [
		'idealPosition',
		'forceSteps'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> activateForces [
	
	forceSteps := 100.
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> applyForces [
	
	velocity := 0 @ 0.
	
	self morph owner submorphsDo: [:otherMorph |
		(otherMorph isSandblock and: [
			otherMorph preventOcclusion and: [
				otherMorph ~= self morph]]) ifTrue: [
			velocity := velocity + (self forceAgainst: otherMorph) + (self attractionTo: otherMorph)]].
	
	(velocity r < 0.5)
		ifTrue: [velocity := 0 @ 0]
		ifFalse: [
			idealPosition := self morph position + velocity]
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> attractionTo: otherMorph [
	
	^ self morph attractionTo: otherMorph
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> avoidCollisions [

	self isDragging ifTrue: [^ self].
	self morph owner submorphsDo: [:otherMorph |
		(otherMorph isSandblock and: [
			otherMorph preventOcclusion and: [
						(self morph bounds containsRect: otherMorph bounds) not]]) ifTrue: [
			self immediatelyResolveCollisionWith: otherMorph]].
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> forceAgainst: otherMorph [
	
	^ self morph forceAgainst: otherMorph
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> immediatelyResolveCollisionWith: otherMorph [

	| direction distanceNeeded |
	direction := (self morph center = otherMorph center
		ifTrue: [ThreadSafeRandom next @ ThreadSafeRandom next]
		ifFalse: [self morph center - otherMorph center]).
	
	distanceNeeded := (self morph extent r + otherMorph extent r) / 2.
	
	direction r < distanceNeeded
		ifTrue: [idealPosition := idealPosition + (direction normalized  * (distanceNeeded - direction r))]
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> initialize [
	
	super initialize.
	self activateForces.
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> step [
	
	idealPosition ifNil: [idealPosition := self morph position].
	
	self isDragging ifTrue: [^ self].
	
	forceSteps > 0
		ifTrue:
			[self applyForces.
			forceSteps := forceSteps - 1.
			self morph position: idealPosition]
		ifFalse:
			[super step.
			idealPosition := self morph position].
	
]
