Class {
	#name : #SBForceMoveDecorator,
	#superclass : #SBMoveDecorator,
	#instVars : [
		'idealPosition',
		'forceSteps',
		'additionalForces',
		'pinnedPosition',
		'previousVelocity',
		'speedMultiplier',
		'group'
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

	| newSpeedMultiplier |
	
	self isPinned ifTrue: [^ self morph position: self pinnedPosition].
	self isDragging ifTrue: [^ self].
	
	velocity := 0 @ 0.
	self additionalForces do: [:forceConnection | velocity := velocity + (forceConnection forceFor: self morph)].
	velocity isZero ifFalse: [velocity := velocity normalized * velocity r sqrt].
	
	self morph owner submorphsDo: [:otherMorph | (otherMorph isSandblock and: [otherMorph preventOcclusion and: [otherMorph ~= self morph and: [otherMorph isDragging not]]]) ifTrue: [velocity := velocity + (self forceAgainst: otherMorph)]].
	
	newSpeedMultiplier := self speedMultiplier * (self changedDirection ifTrue: [0.25] ifFalse: [1.1]).
	self speedMultiplier: (newSpeedMultiplier clampLow: 0.01 high: 0.5).
	
	(velocity r < 0.5 or: [self speedMultiplier <= 0.01]) ifFalse: [idealPosition := self morph position + (velocity * self speedMultiplier)].
	self previousVelocity: velocity.
	self morph position: idealPosition.
	velocity := 0 @ 0.
	forceSteps := forceSteps - 1
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> attached: aMorph [

	super attached: aMorph.
	self idealPosition: aMorph position
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
	
	self morph owner childSandblocksDo: [:block |
		((block bounds containsPoint: aPoint)
			and: [block bounds area > bestArea]
			and: [block ~= self morph]) ifTrue: [
			best := block.
			bestArea := block bounds area]].
	
	^ best
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> changedDirection [
	
	^ velocity isZero or:
		[self previousVelocity isZero] or:
		[(velocity angleWith: self previousVelocity) between: Float pi * 0.5 and: Float pi * 1.5]
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> createImplicitForces [
	
	self morph sandblockEditor childSandblocks reverseDo: [:otherMorph |
		(otherMorph preventOcclusion and: [
			otherMorph ~= self morph and: [
				otherMorph isDragging not]]) ifTrue: [ | attraction |
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
SBForceMoveDecorator >> group [

	^ group
]

{ #category : #accessing }
SBForceMoveDecorator >> group: anObject [

	group := anObject.
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
		pinnedPosition: nil;
		activateForces;
		previousVelocity: 0@0;
		speedMultiplier: 1.0;
		additionalForces: OrderedCollection new.
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> isForceCoordinator [

	^ self morph = (self morph owner submorphs detect: [:block | block isSandblock and: [block hasDecorator: SBForceMoveDecorator]])
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> isPinned [

	^ self pinnedPosition notNil
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> mouseUp: anEvent [
	
	self isDragging ifTrue: [ | otherBlock |
		self idealPosition: self morph position.
		self pinnedPosition ifNotNil: [self pinnedPosition: self morph position].
		otherBlock := self blockAtPoint: anEvent position.
		otherBlock ifNotNil: 
			[self morph sandblockEditor 
				openMorphBack: (SBForceConnector connect: self morph to: otherBlock);
				activateForces]].
	super mouseUp: anEvent.
	
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

	SBPreferences enableForceLayout ifFalse: [^ super step].

	idealPosition ifNil: [idealPosition := self morph position].
	
	self isDragging ifTrue: [self panWhenNearEdge].
	
	(forceSteps > 0 or: self morph sandblockEditor keepForcesActivated)
		ifTrue: [self isForceCoordinator ifTrue: [50 timesRepeat: [self morph owner submorphsDo: [:aMorph | aMorph isSandblock ifTrue: [aMorph withDecorator: SBForceMoveDecorator do: [:decorator | decorator applyForces]]]]]]
		ifFalse: [
			super step.
			idealPosition := self morph position]
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> stepTime [

	^ 25
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> togglePinned [

	<action>
	
	self pinnedPosition: (self pinnedPosition ifNil: [self morph position] ifNotNil: [nil])
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> unregisterAdditionalForce: aForce [

	self additionalForces remove: aForce.
]
