Class {
	#name : #SBForceMoveDecorator,
	#superclass : #SBMoveDecorator,
	#instVars : [
		'idealPosition',
		'forceSteps',
		'additionalForces'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBForceMoveDecorator class >> configured [

	^ SBPreferences enableForceLayout
		ifTrue: [self]
		ifFalse: [SBMoveDecorator]
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator class >> newConfigured [

	^ self configured new
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> activateForces [
	
	forceSteps := 100.
]

{ #category : #accessing }
SBForceMoveDecorator >> additionalForces [

	^ additionalForces
]

{ #category : #accessing }
SBForceMoveDecorator >> additionalForces: anObject [

	additionalForces := anObject.
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
	
	self additionalForces do: [:forceConnection | velocity := velocity + (forceConnection forceFor: self morph)].
	
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
	
	self morph owner childSandblocksDo: [:block |
		((block bounds containsPoint: aPoint)
			and: [block bounds area > bestArea]
			and: [block ~= self morph]) ifTrue: [
			best := block.
			bestArea := block bounds area]].
	
	^ best
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> deactivateForces [
	
	forceSteps := 0.
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
	self activateForces.
	self additionalForces: OrderedCollection new.
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> mouseUp: anEvent [
	
	self isDragging ifTrue: [ | otherBlock |
		otherBlock := self blockAtPoint: anEvent position.
		otherBlock ifNotNil: 
			[self morph sandblockEditor 
				openMorphBack: (SBForceConnector connect: self morph to: otherBlock);
				activateForces]].
	super mouseUp: anEvent.
	
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> registerAdditionalForce: aForce [

	self additionalForces add: aForce.
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> step [

	SBPreferences enableForceLayout ifFalse: [^ super step].
	
	idealPosition ifNil: [idealPosition := self morph position].
	
	self isDragging ifTrue: [^ self].
	
	forceSteps > 0
		ifTrue: [
			self applyForces.
			forceSteps := forceSteps - 1.
			self morph position: idealPosition]
		ifFalse: [
			super step.
			idealPosition := self morph position]
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> stepTime [
	
	^ 25
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> unregisterAdditionalForce: aForce [

	self additionalForces remove: aForce.
]
