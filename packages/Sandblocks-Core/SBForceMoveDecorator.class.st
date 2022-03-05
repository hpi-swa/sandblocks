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

	| newSpeedMultiplier forceVelocity |
	self isPinned ifTrue: [^ self morph position: self pinnedPosition].
	self isDragging ifTrue: [^ self].
	
	idealPosition ifNil: [idealPosition := self morph position].
	
	forceVelocity := 0 @ 0.
	self additionalForces do: [:forceConnection | forceVelocity := forceVelocity + (forceConnection forceFor: self morph)].
	forceVelocity isZero ifFalse: [forceVelocity := forceVelocity normalized * forceVelocity r sqrt].
	
	self morph owner submorphsDo: [:otherMorph | (otherMorph isSandblock and: [otherMorph preventOcclusion and: [otherMorph ~= self morph and: [otherMorph isDragging not]]]) ifTrue: [forceVelocity := forceVelocity + (self forceAgainst: otherMorph)]].
	
	newSpeedMultiplier := self speedMultiplier * ((self changedDirection: forceVelocity) ifTrue: [0.25] ifFalse: [1.1]).
	self speedMultiplier: (newSpeedMultiplier clampLow: 0.01 high: 0.5).
	
	(forceVelocity r < 2.0 or: [self speedMultiplier <= 0.01]) ifFalse: [idealPosition := idealPosition + (forceVelocity * self speedMultiplier)].
	self previousVelocity: forceVelocity.
	velocity := 0 @ 0.
	forceSteps := forceSteps - 1
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> applyIdealPosition [
	
	self morph position: self idealPosition 
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> attached: aMorph [

	super attached: aMorph.
	self group: nil.
	self idealPosition: aMorph position
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> attractionTo: otherMorph [
	
	^ self morph attractionTo: otherMorph
]

{ #category : #nil }
SBForceMoveDecorator >> block: aBlock [
	"ignore this for performAction in block"

	
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> blockAtPoint: aPoint [
	
	^ self morphAtPoint: aPoint satisfying: [:aMorph | aMorph isSandblock]
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> changedDirection: aVelocity [
	
	^ aVelocity isZero or:
		[self previousVelocity isZero] or:
		[(aVelocity angleWith: self previousVelocity) between: Float pi * 0.5 and: Float pi * 1.5]
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> coordinateForces [

	| decorators |
	decorators := Array streamContents: [:stream |
		self morph owner submorphsDo: [:aMorph | aMorph isSandblock ifTrue: [aMorph withDecorator: SBForceMoveDecorator do: [:decorator | stream nextPut: decorator] ifAbsent: []]]
		].

	50 timesRepeat: [
		decorators do: [:decorator | decorator applyForces].
		decorators do: [:decorator | decorator applyIdealPosition]
		]
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> createForceWith: otherBlock [

	self morph sandblockEditor
		openMorph: (SBForceConnector connect: self morph to: otherBlock);
		activateForces
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> createImplicitForceWith: otherMorph [

	| attraction |
	attraction := self attractionTo: otherMorph.
	attraction > 0 ifFalse: [^ self].
	self group
		ifNil: [
			otherMorph group
				ifNil: [ | newGroup |
					self morph sandblockEditor openMorph: (SBForceConnector connect: self morph to: otherMorph forceScale: attraction).
					newGroup := SBGroup new.
					self morph sandblockEditor openMorph: newGroup.
					newGroup addBlocksConnectedTo: self]
				ifNotNil: [otherMorph group addViaDecorator: self]]
		ifNotNil: [
			otherMorph group
				ifNotNil: [self group = otherMorph group ifFalse: [self morph sandblockEditor openMorph: (SBForceConnector connect: self morph to: otherMorph forceScale: attraction)]]
				ifNil: [self group addBlock: otherMorph]]
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> createImplicitForces [
	
	self morph sandblockEditor ifNotNil: [:editor | editor childSandblocks ifNotNil: [:blocks | blocks reverseDo: [:otherMorph |
		(otherMorph preventOcclusion and: [
			otherMorph ~= self morph]) ifTrue: [
				self createImplicitForceWith: otherMorph]]]].
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> deactivateForces [
	
	forceSteps := 0.
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> detached: aMorph [

	super detached: aMorph.
	idealPosition := nil
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> example [

	SBMorphExample
		setUp: [
			SBEditor new
				extent: 1000 @ 600;
				position: 0 @ 0;
				openMorph: self exampleMorphForRepelDistance;
				openMorph: self exampleMorphForAttraction;
				yourself]
		cases: {SBMorphExampleCase name: 'example 1' caseBlock: [:m | m]}
		extent: 1000 @ 600
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> exampleMorphForAttraction [

	| playground |
	playground := (SBStPlayground
		newFromSource: '''Weee! Forces sure are fun.'''
		named: 'Other Block'
		at: 5 @ 5)
		layoutChanged;
		fullBounds;
		detachDecorators: SBForceMoveDecorator;
		yourself.
	^ SBBlock new
		attachDecorator: SBForceMoveDecorator new;
		addMorph: playground;
		extent: playground extent + (10 @ 10);
		position: 0 @ 0;
		yourself
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> exampleMorphForRepelDistance [

	| playground rectangleMorph block |
	playground := (SBStPlayground
		newFromSource: '''This shows the area in which repelling forces are applied'''
		named: 'maxRepelDistance'
		at: 5 @ 5)
		layoutChanged;
		fullBounds;
		detachDecorators: SBForceMoveDecorator;
		yourself.
	rectangleMorph := RectangleMorph new
		extent: playground extent + (SBBlock maxRepelDistance asPoint * 2);
		center: playground extent / 2;
		color: Color transparent;
		borderColor: Color seaFoam;
		borderWidth: 2;
		cornerRadius: SBBlock maxRepelDistance;
		cornerStyle: #rounded.
	block := SBBlock new
		attachDecorator: SBForceMoveDecorator new;
		addMorphBack: playground;
		addMorphBack: rectangleMorph;
		extent: playground extent + (10 @ 10);
		yourself.
	^ block
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
SBForceMoveDecorator >> group: aGroup [

	group := aGroup.
	self morph triggerEvent: #gotGroup
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> hasGroup [
	
	^ self group notNil 
]

{ #category : #accessing }
SBForceMoveDecorator >> idealPosition [

	^ idealPosition
]

{ #category : #accessing }
SBForceMoveDecorator >> idealPosition: aPoint [

	idealPosition := aPoint.
	self pinnedPosition ifNotNil: [self pinnedPosition: aPoint]
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
SBForceMoveDecorator >> isPinned: aBoolean [

	self pinnedPosition: (aBoolean ifTrue: [self morph position] ifFalse: [nil])
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> morphAtPoint: aPoint satisfying: aBlock [

	| best bestArea |
	best := nil.
	bestArea := 0.
	
	self morph owner submorphsDo: [:aMorph |
		((aMorph containsPoint: aPoint)
			and: [aMorph bounds area > bestArea]
			and: [aMorph ~= self morph]
			and: [aBlock value: aMorph]) ifTrue: [
			best := aMorph.
			bestArea := aMorph bounds area]].
	
	^ best
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> mouseUp: anEvent [

	self isDragging ifTrue: [ | otherBlock newGroup |
		self idealPosition: self morph position.
		otherBlock := self blockAtPoint: anEvent position.
		otherBlock ifNotNil: [self createForceWith: otherBlock] ifNil: [
			self group ifNil: [
				newGroup := self
					morphAtPoint: anEvent position
					satisfying: [:aMorph | aMorph isKindOf: SBGroup].
				newGroup ifNotNil: [newGroup addViaDecorator: self]]].
		
		].
	super mouseUp: anEvent
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	self idealPosition: nil
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
		color := self morph colorPolicy selectionColorForBlock: (self morph parentSandblock ifNil: [self morph]).
		b := self morph bounds expandBy: 5.
		self morph invalidRect: (self morph outerBounds expandBy: 5).
		aCanvas frameRoundRect: b radius: self morph colorPolicy cornerRadius width: 5 color: color]
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

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> removeFromGroup [

	<action>
	<actionValidIf: #hasGroup>
	
	(self additionalForces select: [:aForce | aForce to group = aForce from group]) do: [:aForce | aForce abandon].
	self group remove: self morph
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

	(SBPreferences enableForceLayout not or: [self morph sandblockEditor isSingleArtefactView]) ifTrue: [^ super step].
	
	self isDragging ifTrue: [self panWhenNearEdge].
	
	forceSteps > 0
		ifTrue: [self isForceCoordinator ifTrue: [self coordinateForces]]
		ifFalse: [
			super step.
			idealPosition := self morph position]
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> stepTime [

	^ 25
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> togglePinForGroup [
	<action>

	| pinAll |
	pinAll := self isPinned not.
	self group blocks do: [:aBlock | aBlock withDecorator: SBForceMoveDecorator do: [:aDecorator | aDecorator isPinned: pinAll]]
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> togglePinned [
	<action>

	self isPinned: self isPinned not
]

{ #category : #'as yet unclassified' }
SBForceMoveDecorator >> unregisterAdditionalForce: aForce [

	self additionalForces remove: aForce ifAbsent: []
]
