Class {
	#name : #SBForceMoveDecorator,
	#superclass : #SBMoveDecorator,
	#instVars : [
		'idealPosition',
		'forceSteps',
		'additionalForces',
		'pinnedPosition',
		'previousVelocity',
		'speedMultiplier'
	],
	#category : #'Sandblocks-Core'
}

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

	| maxAttractionForce |
	velocity := 0 @ 0.
	maxAttractionForce := 0.
	self additionalForces do: [:forceConnection | velocity := velocity + (forceConnection forceFor: self morph)].
	velocity r > maxAttractionForce ifTrue: [velocity := velocity normalized * ((velocity r - maxAttractionForce) sqrt + maxAttractionForce)].
	
	self morph owner submorphsDo: [:otherMorph | (otherMorph isSandblock and: [otherMorph preventOcclusion and: [otherMorph ~= self morph and: [otherMorph isDragging not]]]) ifTrue: [velocity := velocity + (self forceAgainst: otherMorph)]].
	
	((velocity angleWith: self previousVelocity)
		between: Float pi * 0.5
		and: Float pi * 1.5)
		ifTrue: [self speedMultiplier: self speedMultiplier / 4.0]
		ifFalse: [self speedMultiplier: (self speedMultiplier * 1.1 min: 2.0 max: 0.01)].
	
	(velocity r < 0.5 or: [self speedMultiplier <= 0.01])
		ifTrue: [velocity := 0 @ 0]
		ifFalse: [idealPosition := self morph position + (velocity * self speedMultiplier)].
	self previousVelocity: velocity
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> attractionTo: otherMorph [
	
	^ self morph attractionTo: otherMorph
]

{ #category : #nil }
SBForceMoveDecorator >> block: aBlock [

	"ignore this for performAction in Block"
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> blockAtPoint: aPoint [

	| best bestArea |
	best := nil.
	bestArea := 0.
	
	self morph owner submorphsDo: [:block |
		((block bounds containsPoint: aPoint) and: [block bounds area > bestArea] and: [block ~= self morph] and: [block isSandblock]) ifTrue: [
			best := block.
			bestArea := block bounds area]].
	
	^ best
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> createImplicitForces [
	
	self morph owner submorphsReverseDo: [:otherMorph |
		(otherMorph isSandblock and: [
			otherMorph preventOcclusion and: [
				otherMorph ~= self morph and: [
					otherMorph isDragging not]]]) ifTrue: [ | attraction |
						attraction := self attractionTo: otherMorph.
						attraction > 0 ifTrue: [
							self morph sandblockEditor openMorphBack: (SBForceConnector connect: self morph to: otherMorph forceScale: attraction)]]].
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
	self
		unpin;
		activateForces;
		previousVelocity: 0@0;
		speedMultiplier: 1.0;
		additionalForces: OrderedCollection new.
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> isPinned [

	^ self pinnedPosition notNil
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> mouseUp: anEvent [
	
	self isDragging ifTrue: [ | otherBlock |
		self idealPosition: self morph position.
		self pinnedPosition ifNotNil: [self pinHere].
		otherBlock := self blockAtPoint: anEvent position.
		otherBlock ifNotNil: 
			[self morph sandblockEditor 
				openMorphBack: (SBForceConnector connect: self morph to: otherBlock);
				activateForces]].
	super mouseUp: anEvent.
	
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> pinHere [

	<action>
	
	self pinnedPosition: self morph position.
]

{ #category : #accessing }
SBForceMoveDecorator >> pinnedPosition [

	^ pinnedPosition
]

{ #category : #accessing }
SBForceMoveDecorator >> pinnedPosition: aPoint [

	pinnedPosition := aPoint.
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> postDrawOn: aCanvas [

	| b color |
	
	self isPinned ifTrue: [
		color :=  self morph colorPolicy selectionColorForBlock: (self morph parentSandblock ifNil: [self morph]).
		b := self morph bounds expandBy: 5.
		self morph invalidRect: (self morph outerBounds expandBy: 12).
		aCanvas
			frameRoundRect: b
				radius: self morph colorPolicy cornerRadius
				width: 5
				color: color]
]

{ #category : #accessing }
SBForceMoveDecorator >> previousVelocity [

	^ previousVelocity
]

{ #category : #accessing }
SBForceMoveDecorator >> previousVelocity: anObject [

	previousVelocity := anObject.
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> registerAdditionalForce: aForce [

	self additionalForces add: aForce.
]

{ #category : #accessing }
SBForceMoveDecorator >> speedMultiplier [

	^ speedMultiplier
]

{ #category : #accessing }
SBForceMoveDecorator >> speedMultiplier: anObject [

	speedMultiplier := anObject.
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> step [
	
	idealPosition ifNil: [idealPosition := self morph position].
	
	self isDragging ifTrue: [^ self panWhenNearEdge].
	
	self isPinned ifTrue: [
		^ self morph position: self pinnedPosition].
	
	(forceSteps > 0 or: self morph sandblockEditor keepForcesActivated)
		ifTrue:
			[self applyForces.
			forceSteps := forceSteps - 1.
			self morph position: idealPosition.
			
			"set SBMoveDecorator velocity to 0, else it'll carry over previous movements"
			velocity := 0@0]
		ifFalse:
			[super step.
			idealPosition := self morph position].
	
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> stepTime [

	^ 25
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> unpin [

	<action>
	
	self pinnedPosition: nil
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> unregisterAdditionalForce: aForce [

	self additionalForces remove: aForce.
]
