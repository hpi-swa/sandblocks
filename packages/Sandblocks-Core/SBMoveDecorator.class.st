"
A SBMoveDecorator will allow dragging a morph (without lifting it). If preventOcclusion is set to true, it will also step to ensure that no other sibling morphs overlap its morph.
"
Class {
	#name : #SBMoveDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'lastDragPosition',
		'velocity',
		'preventOcclusion'
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
	
	velocity := 0 @ 0.
	preventOcclusion := true
]

{ #category : #testing }
SBMoveDecorator >> isDragging [

	^ lastDragPosition notNil
]

{ #category : #'event handling' }
SBMoveDecorator >> mouseMove: anEvent [

	lastDragPosition ifNotNil: [
		self morph position: self morph position + (anEvent position - lastDragPosition).
		lastDragPosition := anEvent position]
]

{ #category : #'event handling' }
SBMoveDecorator >> mouseUp: anEvent [

	lastDragPosition ifNotNil: [
		anEvent hand releaseMouseFocus: self.
		lastDragPosition := nil]
]

{ #category : #accessing }
SBMoveDecorator >> preventOcclusion [

	^ preventOcclusion
]

{ #category : #accessing }
SBMoveDecorator >> preventOcclusion: aBoolean [

	preventOcclusion := aBoolean
]

{ #category : #'event handling' }
SBMoveDecorator >> startDrag: anEvent [

	lastDragPosition := anEvent position
]

{ #category : #stepping }
SBMoveDecorator >> step [

	self isDragging ifTrue: [^ self].
	self morph owner submorphsDo: [:morph | 
		(morph preventOcclusion and: [morph ~= self morph and: [(self morph bounds intersects: morph bounds) and: [(self morph bounds containsRect: morph bounds) not]]])
			ifTrue: [ | speed intersection direction maxSpeed |
				intersection := self morph bounds intersect: morph bounds.
				speed := intersection area.
				direction := Point fromSide: (morph bounds sideNearestTo: intersection center).
				velocity := velocity + ((direction * 0.005) * speed).
				maxSpeed := 45.
				velocity := (velocity x clampLow: maxSpeed negated high: maxSpeed) @ (velocity y clampLow: maxSpeed negated high: maxSpeed)]].
	(velocity closeTo: 0 @ 0)
		ifTrue: [velocity := 0 @ 0]
		ifFalse: [
			velocity := velocity * 0.5.
			self morph position: self morph position + velocity]
]

{ #category : #stepping }
SBMoveDecorator >> stepTime [

	^ self preventOcclusion ifTrue: [1] ifFalse: [-1]
]
