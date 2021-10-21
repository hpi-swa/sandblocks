"
A SBEditorCanvas is an infite scrolling morph that clips its submorphs. Via 2d scroll viewport can be moved around. It supports smoothly animating to positions or rectangles in its coordinate system.
"
Class {
	#name : #SBEditorCanvas,
	#superclass : #SBClippingTransformMorph,
	#instVars : [
		'dragging',
		'lastDragPosition',
		'dragStartPosition',
		'dragLeftOverVelocity',
		'targetPosition'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBEditorCanvas >> addMorphToOverlay: aMorph [
	"Do nothing"
]

{ #category : #'as yet unclassified' }
SBEditorCanvas >> addedMorph: aMorph [

	aMorph isSandblock ifTrue: [
		self sandblockEditor activateForces.
		aMorph attachDecorator: SBIndicatorDecorator new]
]

{ #category : #viewport }
SBEditorCanvas >> animateToPosition: aPoint [

	targetPosition := aPoint
]

{ #category : #viewport }
SBEditorCanvas >> basicViewportPosition: aPoint [

	(aPoint - self position) ~= self transform offset ifTrue: [
		self transform: (self transform withOffset: aPoint - self position).
		self changed]
]

{ #category : #'as yet unclassified' }
SBEditorCanvas >> canvasTransform [

	^ self transformFrom: nil
]

{ #category : #'event handling' }
SBEditorCanvas >> click: anEvent [

	self sandblockEditor click: anEvent
]

{ #category : #'geometry testing' }
SBEditorCanvas >> containsPoint: aPoint [

	^ self bounds containsPoint: aPoint
]

{ #category : #accessing }
SBEditorCanvas >> currentPosition [

	^ self position + self transform offset
]

{ #category : #'geometry testing' }
SBEditorCanvas >> defaultColor [

	^ (self sandblockEditor ifNotNil: [:editor | editor colorPolicy ifNotNil: [:c | c colorForEditor: self]]) ifNil: [Color white]
]

{ #category : #drawing }
SBEditorCanvas >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas
	
	"aCanvas asBalloonCanvas transformBy: self transform
		during:[:myCanvas| submorphs reverseDo: [:m | myCanvas fullDrawMorph: m]]"
]

{ #category : #accessing }
SBEditorCanvas >> extentToFit [

	| full |
	full := self submorphBounds.
	^ full extent + ((full origin max: 0 @ 0) - self position)
]

{ #category : #viewport }
SBEditorCanvas >> finishDragVelocity [

	self moveViewport: dragLeftOverVelocity.
	dragLeftOverVelocity := dragLeftOverVelocity * 0.85.
	(dragLeftOverVelocity closeTo: 0 @ 0)
		ifTrue: [
			self viewportPosition: targetPosition rounded.
			self stopSteppingSelector: #finishDragVelocity]
]

{ #category : #'event handling' }
SBEditorCanvas >> handlesMouseDown: anEvent [

	^ true
]

{ #category : #'event handling' }
SBEditorCanvas >> handlesMouseWheel: anEvent [

	^ true
]

{ #category : #initialization }
SBEditorCanvas >> initialize [

	super initialize.
	
	dragging := false.
	targetPosition := 0 @ 0.
	dragLeftOverVelocity := 0 @ 0.
	color := nil.
	self smoothing: 2
]

{ #category : #'event handling' }
SBEditorCanvas >> mouseDown: anEvent [

	anEvent hand waitForClicksOrDrag: self event: anEvent.
	self stopSteppingSelector: #finishDragVelocity.
	
	anEvent yellowButtonPressed ifTrue: [
		lastDragPosition := anEvent position.
		dragging := true]
]

{ #category : #'event handling' }
SBEditorCanvas >> mouseMove: anEvent [ 
	dragging
		ifTrue: [| delta |
			delta := anEvent position - lastDragPosition.
			self moveViewport: delta.
			lastDragPosition := anEvent position.
			"dragLeftOverVelocity := delta"]
]

{ #category : #'event handling' }
SBEditorCanvas >> mouseUp: anEvent [ 
	(dragLeftOverVelocity closeTo: 0 @ 0)
		ifFalse: [self startSteppingSelector: #finishDragVelocity].
	dragging := false
]

{ #category : #'event handling' }
SBEditorCanvas >> mouseWheel: anEvent [

	self viewportPosition: targetPosition + (anEvent wheelDelta * (1 @ -1))
]

{ #category : #viewport }
SBEditorCanvas >> moveViewport: aPoint [

	self viewportPosition: targetPosition + aPoint negated
]

{ #category : #constants }
SBEditorCanvas >> scrollShowMargin [

	^ 10 * self scalingFactor
]

{ #category : #'as yet unclassified' }
SBEditorCanvas >> scrollToCenter: aMorph [

	self animateToPosition: aMorph center - (self center - self topLeft)
]

{ #category : #viewport }
SBEditorCanvas >> scrollToShow: aMorph [

	| viewport x y target c |
	aMorph ensureLayouted.
	
	viewport := 0 @ 0 extent: self extent.
	target := (aMorph boundsInWorld translateBy: self topLeft negated) expandBy: self scrollShowMargin.
	(viewport containsRect: target) ifTrue: [
		self viewportPosition: self currentPosition.
		^ self].
	
	c := self currentPosition.
	x := c x.
	y := c y.
	target right > viewport right ifTrue: [x := target right - viewport right + c x min: target left - viewport left + c x].
	target left < viewport left ifTrue: [x := target left - viewport left + c x].
	target bottom > viewport bottom ifTrue: [y := target bottom - viewport bottom + c y min: target top - viewport top + c y].
	target top < viewport top ifTrue: [y := target top - viewport top + c y].
	
	" don't move on an axis where we cannot fit "
	(viewport intersects: target) ifTrue: [
		target width > viewport width ifTrue: [x := c x].
		target height > viewport height ifTrue: [y := c y]].
	
	self animateToPosition: x @ y
]

{ #category : #accessing }
SBEditorCanvas >> scroller [

	^ self
]

{ #category : #'event handling' }
SBEditorCanvas >> startDrag: anEvent [

	| canvas |
	anEvent redButtonPressed
		ifTrue: [
			SBPreferences drawOnCanvas ifTrue: [
				canvas := SBDrawCanvas new center: (self transform globalPointToLocal: anEvent position).
				self addMorphBack: canvas.
				canvas mouseDown: (anEvent transformedBy: self transform).
				anEvent hand newMouseFocus: canvas]]
		ifFalse: [
			dragging := true.
			lastDragPosition := anEvent position.
			dragStartPosition := anEvent position]
]

{ #category : #'stepping and presenter' }
SBEditorCanvas >> step [

	(dragLeftOverVelocity closeTo: 0 @ 0)
		ifTrue: [
			((self currentPosition dist: self targetPosition) closeTo: 0)
				ifTrue: [self currentPosition ~= self targetPosition ifTrue: [self viewportPosition: self targetPosition rounded]]
				ifFalse: [self basicViewportPosition: (self currentPosition interpolateTo: self targetPosition at: 0.2)]]
]

{ #category : #'stepping and presenter' }
SBEditorCanvas >> stepTime [

	^ 1
]

{ #category : #accessing }
SBEditorCanvas >> targetPosition [

	^ targetPosition
]

{ #category : #viewport }
SBEditorCanvas >> viewportPosition: aPoint [

	targetPosition := aPoint.
	self basicViewportPosition: aPoint
]

{ #category : #viewport }
SBEditorCanvas >> zoomViewport: aNumber from: aPoint [

	self offset: self offset + ((aPoint - self position) * aNumber * self scale * 0.001).
	self scale: (self scale + (aNumber * self scale * 0.001))
]
