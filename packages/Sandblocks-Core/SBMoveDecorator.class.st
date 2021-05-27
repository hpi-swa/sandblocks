"
A SBMoveDecorator will allow dragging a morph (without lifting it). If preventOcclusion is set to true, it will also step to ensure that no other sibling morphs overlap its morph.
"
Class {
	#name : #SBMoveDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'lastDragPosition',
		'velocity'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #callbacks }
SBMoveDecorator >> attached: aMorph [

	super attached: aMorph.
	
	(self installEventBroadcasterFor: aMorph)
		when: #mouseMove send: #mouseMove: to: self;
		when: #startDrag send: #startDrag: to: self;
		when: #mouseUp send: #mouseUp: to: self
]

{ #category : #'as yet unclassified' }
SBMoveDecorator >> canMove [

	^ self morph floating
]

{ #category : #callbacks }
SBMoveDecorator >> detached: aMorph [

	self uninstallEventBroadcaster.
	
	super detached: aMorph
]

{ #category : #'event handling' }
SBMoveDecorator >> handlesClickOrDrag: anEvent [

	^ true
]

{ #category : #'event handling' }
SBMoveDecorator >> handlesGestureStart: anEvent [

	^ true
]

{ #category : #'event handling' }
SBMoveDecorator >> handlesKeyboard: anEvent [

	^ false
]

{ #category : #'initialize-release' }
SBMoveDecorator >> initialize [

	super initialize.
	
	velocity := 0 @ 0
]

{ #category : #testing }
SBMoveDecorator >> isDragging [

	^ lastDragPosition notNil
]

{ #category : #'as yet unclassified' }
SBMoveDecorator >> mouseCursorAt: anEvent [

	(self canMove and: [
		(self morph morphsAt: anEvent position)
			ifNotEmpty: [:l | l first = self morph]
			ifEmpty: [false]]) ifTrue: [^ {Cursor crossHair. 0}].
	^ nil
]

{ #category : #'event handling' }
SBMoveDecorator >> mouseMove: anEvent [
	
	lastDragPosition ifNotNil: [
		self morph position: self morph position + (anEvent position - lastDragPosition).
		lastDragPosition := anEvent position.
		self morph sandblockEditor instantlyScrollToShow: self morph.]
]

{ #category : #'event handling' }
SBMoveDecorator >> mouseUp: anEvent [

	lastDragPosition ifNotNil: [
		anEvent hand releaseMouseFocus: self.
		lastDragPosition := nil]
]

{ #category : #'as yet unclassified' }
SBMoveDecorator >> resolveCollisionCenteredWith: otherMorph [

	| intersection speed direction speedFactor |
	intersection := self morph bounds intersect: otherMorph bounds.
	speed := intersection area.
	direction := (self morph center = otherMorph center
		ifTrue: [ThreadSafeRandom next @ ThreadSafeRandom next]
		ifFalse: [self morph center - otherMorph center]) normalized.
	speedFactor := 0.005.
	^ direction * (speed * speedFactor)
]

{ #category : #'as yet unclassified' }
SBMoveDecorator >> resolveCollisionWith: otherMorph [

	| intersection speed direction maxSpeed |
	intersection := self morph bounds intersect: otherMorph bounds.
	speed := intersection area.
	direction := Point fromSide: (otherMorph bounds sideNearestTo: intersection center).
	velocity := velocity + ((direction * 0.005) * speed).
	maxSpeed := 45.
	^ (velocity x clampLow: maxSpeed negated high: maxSpeed) @ (velocity y clampLow: maxSpeed negated high: maxSpeed)
]

{ #category : #'event handling' }
SBMoveDecorator >> startDrag: anEvent [

	lastDragPosition := anEvent position
]

{ #category : #stepping }
SBMoveDecorator >> step [

	self isDragging ifTrue: [^ self].
	self morph owner submorphsDo: [:otherMorph |
		(otherMorph isSandblock and: [
			otherMorph preventOcclusion and: [
				otherMorph ~= self morph and: [
					(self morph bounds intersects: otherMorph bounds) and: [
						(self morph bounds containsRect: otherMorph bounds) not and: [
							otherMorph isDragging not]]]]]) ifTrue: [
			velocity := self resolveCollisionCenteredWith: otherMorph]].
	
	(velocity closeTo: 0 @ 0)
		ifTrue: [velocity := 0 @ 0]
		ifFalse: [
			velocity := velocity * 0.5.
			self morph position: self morph position + (velocity max: velocity sign)]
]

{ #category : #stepping }
SBMoveDecorator >> stepTime [

	^ self morph preventOcclusion ifTrue: [1] ifFalse: [-1]
]
