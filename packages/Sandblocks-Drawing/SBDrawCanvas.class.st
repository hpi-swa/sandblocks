Class {
	#name : #SBDrawCanvas,
	#superclass : #Morph,
	#instVars : [
		'drawing',
		'stampForm',
		'paintingForm',
		'lastMousePosition',
		'lastTouchPositions',
		'previousHigherPerformance'
	],
	#category : #'Sandblocks-Drawing'
}

{ #category : #'as yet unclassified' }
SBDrawCanvas >> beginDraw [

	previousHigherPerformance ifNil: [
		previousHigherPerformance := Preferences valueOfFlag: #higherPerformance.
		Preferences setFlag: #higherPerformance toValue: true]
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> createStampOfSize: aNumber [

	| form |
	SBExample self: [SBDrawCanvas basicNew] args: [{32}] label: 'small'.
	form := Form extent: aNumber asPoint depth: 32.
	form getCanvas
		fillRectangle: form boundingBox
		fillStyle: ((GradientFillStyle ramp: {(0.0 -> (Color white alpha: 0.9)). (0.8 -> (Color white alpha: 0))})
			 origin: aNumber asPoint // 2;
			 radial: true;
			 direction: aNumber asPoint // 2;
			 yourself).
	SBExampleWatch report: (form := form collectColors: [:col | Color black alpha: col red]) for: 893886548.
	^ form
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> drawOn: aCanvas [ 
	aCanvas translucentImage: paintingForm at: self position
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> endDraw [

	Preferences setFlag: #higherPerformance toValue: previousHigherPerformance.
	previousHigherPerformance := nil
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> ensurePointReachable: aPoint [

	| point |
	point := aPoint - self position.
	point x < stampForm width ifTrue: [self growBy: -1 @ 0].
	point y < stampForm height ifTrue: [self growBy: 0 @ -1].
	point x > (paintingForm width - stampForm width) ifTrue: [self growBy: 1 @ 0].
	point y > (paintingForm height - stampForm height) ifTrue: [self growBy: 0 @ 1]
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> example [
	SBMorphExample
		setUp: [SBDrawCanvas new]
		cases: {SBMorphExampleCase name: 'default' caseBlock: [:c | c click]}
		extent: 300 @ 300
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> extent: aPoint [ 
	super extent: paintingForm extent
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> fillFrom: aPoint to: anotherPoint [

	| step |
	self ensurePointReachable: anotherPoint.
	step := aPoint = anotherPoint ifTrue: [1] ifFalse: [1 / (anotherPoint dist: aPoint)].
	0
		to: 1
		by: step
		do: [:val |  | origin |
			origin := aPoint interpolateTo: anotherPoint at: val.
			stampForm
				displayOn: paintingForm
				at: (origin - self position) - (stampForm extent // 2)
				clippingBox: paintingForm boundingBox
				rule: Form blend
				fillColor: nil].
	self invalidRect: ((Rectangle encompassing: {aPoint. anotherPoint}) expandBy: stampForm extent // 2)
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> growBy: aPoint [

	| grow |
	grow := aPoint sign * 50.
	paintingForm := (Form extent: paintingForm form extent + grow abs depth: 32)
		"fillColor: Color white;"
		copyBits: paintingForm boundingBox
		from: paintingForm
		at: (grow negated max: 0 @ 0)
		clippingBox: (0 @ 0 extent: paintingForm form extent + grow abs)
		rule: Form over
		fillColor: nil;
		yourself.
	self extent: paintingForm extent.
	
	(grow x < 0 or: [grow y < 0]) ifTrue: [self position: self position + grow]
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> handleTouchBegin: anEvent [

	lastTouchPositions ifEmpty: [self beginDraw].
	lastTouchPositions at: anEvent sequence put: anEvent position
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> handleTouchEnd: anEvent [

	lastTouchPositions removeKey: anEvent sequence.
	lastTouchPositions ifEmpty: [self endDraw]
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> handleTouchUpdate: anEvent [ 
	self
		fillFrom: (lastTouchPositions
				at: anEvent sequence
				ifAbsent: [^ self])
		to: anEvent position.
	lastTouchPositions at: anEvent sequence put: anEvent position
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> handlesMouseDown: anEvent [

	^ anEvent redButtonPressed
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> handlesMouseMove: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> initialize [

	super initialize.
	paintingForm := Form extent: 100 asPoint depth: 32.
	stampForm := false
		ifTrue: [(Form fromFileNamed: '/home/tom/Pictures/brush.png') scaledIntoFormOfSize: 32 asPoint]
		ifFalse: [self createStampOfSize: 4].
	drawing := false.
	lastTouchPositions := Dictionary new.
	self extent: paintingForm extent
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> isArtefact [ 
	
	^ false
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> morphicLayerNumber [

	^ 101
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> mouseDown: anEvent [

	drawing := true.
	lastMousePosition := anEvent position.
	self beginDraw.
	self mouseMove: anEvent
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> mouseMove: anEvent [

	drawing
		ifTrue: [
			self fillFrom: lastMousePosition to: anEvent position.
			lastMousePosition := anEvent position]
]

{ #category : #'as yet unclassified' }
SBDrawCanvas >> mouseUp: anEvent [

	drawing := false.
	self endDraw
]
