Class {
	#name : #SBForceMoveDecorator,
	#superclass : #SBMoveDecorator,
	#instVars : [
		'idealPosition',
		'forceSteps',
		'force'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> activateForces [
	
	forceSteps := 100.
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> addForce: aPoint [
	
	self force: self force + aPoint
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> applyForces [
	
	velocity := 0 @ 0.
	
	self morph owner submorphsDo: [:otherMorph |
		(otherMorph isSandblock and: [
			otherMorph preventOcclusion and: [
				otherMorph ~= self morph and: [
					otherMorph isDragging not]]]) ifTrue: [
			velocity := velocity + (self forceAgainst: otherMorph) + (self attractionTo: otherMorph)]].
	
	Transcript showln: self force.
	velocity := velocity + self force.
	self force: 0@0.
	
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
SBForceMoveDecorator >> blockAtPoint: aPoint [

	| best bestArea |
	best := nil.
	bestArea := 0.
	
	self morph owner submorphsDo: [:block |
		((block bounds containsPoint: aPoint) and: [block bounds area > bestArea] and: [block ~= self morph]) ifTrue: [
			best := block.
			bestArea := block bounds area]].
	
	^ best
]

{ #category : #accessing }
SBForceMoveDecorator >> force [

	^ force
]

{ #category : #accessing }
SBForceMoveDecorator >> force: anObject [

	force := anObject.
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> forceAgainst: otherMorph [
	
	^ self morph forceAgainst: otherMorph
]

{ #category : #accessing }
SBForceMoveDecorator >> forceSteps [

	^ forceSteps
]

{ #category : #accessing }
SBForceMoveDecorator >> forceSteps: anObject [

	forceSteps := anObject.
]

{ #category : #accessing }
SBForceMoveDecorator >> idealPosition [

	^ idealPosition
]

{ #category : #accessing }
SBForceMoveDecorator >> idealPosition: anObject [

	idealPosition := anObject.
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
	self force: 0@0.
	self activateForces.
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> mouseUp: anEvent [
	
	self isDragging ifTrue: [ | otherBlock |
		otherBlock := self blockAtPoint: anEvent position.
		otherBlock ifNotNil: [self morph sandblockEditor openMorph: (SBForceConnector connect: self morph to: otherBlock)]].
	super mouseUp: anEvent.
	
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
			idealPosition := self morph position.
			self force: 0@0].
	
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> stepTime [
	
	^ 25
]
