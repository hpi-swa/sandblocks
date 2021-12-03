Class {
	#name : #SBConnectorLine,
	#superclass : #Morph,
	#instVars : [
		'from',
		'to',
		'fromAlign',
		'toAlign',
		'lineType',
		'curveModifier',
		'connectorType',
		'evade',
		'lineWidth'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBConnectorLine class >> connect: anObject align: aSymbol to: anotherObject align: anotherSymbol [

	^ self new connect: anObject align: aSymbol to: anotherObject align: anotherSymbol
]

{ #category : #'as yet unclassified' }
SBConnectorLine class >> connect: anObject to: anotherObject [

	^ self new connect: anObject to: anotherObject
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> arrowSize [

	^ 15
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> checkAutoDelete [

	(self isInWorld and: [from isInWorld not or: [to isInWorld not]]) ifTrue: [^ self delete].
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> connect: anObject align: aSymbol to: anotherObject align: anotherSymbol [

	fromAlign := aSymbol.
	toAlign := anotherSymbol.
	self connect: anObject to: anotherObject
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> connect: anObject to: anotherObject [

	from := anObject.
	to := anotherObject.
	from when: #positionChanged send: #update: to: self with: nil.
	to when: #positionChanged send: #update: to: self with: nil.
	from when: #extentChanged send: #update: to: self with: nil.
	to when: #extentChanged send: #update: to: self with: nil.
	from addDependent: self.
	to addDependent: self.
	self update: nil.
	self connectAutoDelete: to.
	self connectAutoDelete: from
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> connectAutoDelete: aBlock [

	aBlock when: #delete send: #delete to: self
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> connectorType [

	^ connectorType
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> connectorType: aSymbol [

	connectorType := aSymbol
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> controlSize [

	^ 150
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> curvePoints [

	self isSelfConnection ifTrue: [^ self curvePointsForSelfConnection].
	self evade ~= #none ifTrue: [^ self curvePointsForEvade].
	^ self endPointsDo: [:a :b | | delta controlSize controlPoint fromControl toControl |
		delta := a - b.
		controlSize := (delta x max: delta y) / 2.
		controlPoint := delta x abs > delta y abs ifTrue: [controlSize @ 0] ifFalse: [0 @ controlSize].
		fromControl := fromAlign = #none ifTrue: [controlPoint * delta sign negated] ifFalse: [(Point fromSide: fromAlign) * self controlSize].
		toControl := toAlign = #none ifTrue: [controlPoint * delta sign] ifFalse: [(Point fromSide: toAlign) * self controlSize].
		{a. (a + fromControl). (b + toControl). b}]
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> curvePointsForEvade [

	| delta controlDistance angle |
	^ self endPointsDo: [:a :b |
		delta := a - b.
		controlDistance := (self width max: self height) / 4.
		angle := (evade = #left ifTrue: [45] ifFalse: [-45]) degreesToRadians.
		{
			a.
			a + (delta normalized negated * controlDistance rotatedBy: angle negated).
			b + (delta normalized * controlDistance rotatedBy: angle).
			b
		}]
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> curvePointsForSelfConnection [

	| pivot |
	pivot := from topCenter.
	^ {
		(from width > 40 ifTrue: [pivot + (-20 @ 0)] ifFalse: [from topLeft]).
		(pivot + (-20 @ self selfConnectionSize negated)).
		(pivot + (20 @ self selfConnectionSize negated)).
		(from width > 40 ifTrue: [pivot + (20 @ 0)] ifFalse: [from topRight])
	}
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> curveWidth [

	^ 2
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> drawArrowOn: aCanvas origin: aPoint delta: anotherPoint [

	aCanvas asBalloonCanvas
		aaLevel: 4;
		line: aPoint to: aPoint + anotherPoint width: 3 color: self color;
		line: aPoint to: aPoint + anotherPoint leftRotated width: 3 color: self color
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> drawConnectorsOn: aCanvas alignBetween: aPoint and: anotherPoint [

	| rotated |
	self connectorType = #arrow ifTrue: [
		rotated := Point r: self arrowSize degrees: (aPoint - anotherPoint) theta radiansToDegrees + 45.
		self drawArrowOn: aCanvas origin: anotherPoint delta: rotated].
	self connectorType = #dots ifTrue: [{aPoint. anotherPoint} do: [:point | aCanvas fillOval: (14 asPoint center: point) color: self color]]
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> drawOn: aCanvas [

	self lineType = #line ifTrue: [
		self endPointsDo: [:a :b |
			aCanvas asBalloonCanvas
				aaLevel: 4;
				line: a to: b width: self lineWidth color: self color.
			self drawConnectorsOn: aCanvas alignBetween: a and: b]].
	self lineType = #curve ifTrue: [ | points |
		points := self curvePoints.
		aCanvas asBalloonCanvas
			aaLevel: 4;
			drawBezier3Shape: points
				color: Color transparent
				borderWidth: self curveWidth
				borderColor: self color.
		self drawConnectorsOn: aCanvas alignBetween: points third and: points last]
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> endPointsDo: aBlock [

	^ aBlock
		value: (fromAlign = #none
			ifTrue: [ | side |
				side := from bounds sideNearestTo: to center.
				from bounds
					line: side
					do: [:a :b |
						(from bounds line: side do: [:a2 :b2 | ((b2 - a2) // 2) + a2]) nearestPointOnLineFrom: a to: b]]
			ifFalse: [from perform: (fromAlign, 'Center') asSymbol])
		value: (toAlign = #none
			ifTrue: [ | side |
				side := to bounds sideNearestTo: from center.
				to bounds
					line: side
					do: [:a :b |
						(to bounds line: side do: [:a2 :b2 | ((b2 - a2) // 2) + a2]) nearestPointOnLineFrom: a to: b]]
			ifFalse: [to perform: (toAlign, 'Center') asSymbol])
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> evade [

	^ evade
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> evade: aDirection [
	" set this line to curve to the #left or the #right or #none "

	evade := aDirection.
	self changed.
	self layoutChanged
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> exampleConnectorType [

	SBMorphExample
		setUp: [SBConnectorLine new connectorType: #dots]
		cases: {
			(SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:m |  | morph |
					m color: (Color r: 0.4 g: 0.4 b: 0.4).
					m
						connect: (Morph new
							color: Color green;
							position: 40 @ 40;
							openInWorld: m owner)
						to: (Morph new
							color: Color yellow;
							position: 177 @ 148;
							openInWorld: m owner)])
		}
		extent: 300 @ 300
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> exampleMorphToMorph [

	SBMorphExample
		setUp: [SBConnectorLine new lineType: #curve]
		cases: {
			(SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:m | 
					m
						connect: (Morph new
							color: Color red;
							openInWorld: m owner;
							position: 139 @ 164)
						to: (Morph new
							color: Color red;
							openInWorld: m owner;
							position: 317 @ 47)])
		}
		extent: 407 @ 264
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> exampleMorphToMorphAlign [

	SBMorphExample
		setUp: [SBConnectorLine new lineType: #curve]
		cases: {
			(SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:m | 
					m
						connect: (Morph new
							 color: Color green;
							 openInWorld: m owner;
							 position: 88 @ 54)
						align: #left
						to: (Morph new
							 color: Color red;
							 openInWorld: m owner;
							 position: 294 @ 150)
						align: #bottom])
		}
		extent: 407 @ 264
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> exampleMorphToSelf [

	SBMorphExample
		setUp: [SBConnectorLine new lineType: #line]
		cases: {
			(SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:m |  | morph |
					m color: Color red.
					morph := Morph new position: 100 @ 100.
					m connect: morph to: morph.
					morph openInWorld: m owner])
		}
		extent: 407 @ 264
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> floating [

	^ true
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> from [

	^ from
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> handlesMouseDown: anEvent [

	^ self endPointsDo: [:start :end |
		anEvent position onLineFrom: start to: end within: 10]
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> initialize [

	super initialize.
	lineType := #line.
	fromAlign := #none.
	toAlign := #none.
	curveModifier := 0.
	connectorType := #arrow.
	evade := #none.
	lineWidth := 3
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> isArtefact [
	
	^ true
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> isConnector [
	
	^ true
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> isSelfConnection [

	^ from = to
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> lineType [

	^ (self isSelfConnection or: [self evade ~= #none]) ifTrue: [#curve] ifFalse: [lineType]
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> lineType: aSymbol [

	lineType := aSymbol
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> lineWidth [
	
	^ lineWidth
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> lineWidth: aNumber [
	
	lineWidth := aNumber
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> morphicLayerNumber [

	^ 101
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> mouseDown: anEvent [

	self sandblockEditor do: (SBDeleteCommand new target: self)
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> outerBounds [

	^ self bounds expandBy: self arrowSize * 2
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> rejectsEvent: anEvent [

	^ (anEvent isMouse and: [anEvent isMouseDown or: [anEvent isMouseMove]]) ifTrue: [(self handlesMouseDown: anEvent) not] ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> replaceToWith: anObject [

	to removeActionsWithReceiver: self.
	to removeDependent: self.
	self update: nil.
	
	to replaceBy: anObject.
	
	to := anObject.
	to when: #positionChanged send: #update: to: self with: nil.
	to addDependent: self.
	self update: nil.
	to when: #outOfWorld send: #delete to: self
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> selfConnectionSize [

	^ 40
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> to [

	^ to
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> update: anAspect [

	| points |
	self checkAutoDelete.
	points := self lineType = #curve ifTrue: [self curvePoints] ifFalse: [self endPointsDo: [:a :b | {a. b}]].
	self bounds: (Rectangle encompassing: points)
]
