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
		'connectorType'
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

	^ 15 withScalingFactor
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
	from addDependent: self.
	to addDependent: self.
	self update: nil.
	from when: #outOfWorld send: #delete to: self.
	to when: #outOfWorld send: #delete to: self
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

	| delta controlSize controlPoint fromControl toControl |
	self isSelfConnection ifTrue: [^ self curvePointsForSelfConnection].
	^ self endPointsDo: [:a :b | 
		delta := a - b.
		controlSize := (delta x max: delta y) / 2.
		controlPoint := delta x abs > delta y abs ifTrue: [controlSize @ 0] ifFalse: [0 @ controlSize].
		fromControl := fromAlign = #none ifTrue: [controlPoint * delta sign negated] ifFalse: [(Point fromSide: fromAlign) * self controlSize].
		toControl := toAlign = #none ifTrue: [controlPoint * delta sign] ifFalse: [(Point fromSide: toAlign) * self controlSize].
		{a. (a + fromControl). (b + toControl). b}]
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
SBConnectorLine >> drawArrowOn: aCanvas origin: aPoint delta: anotherPoint [

	aCanvas line: aPoint to: aPoint + anotherPoint width: 3 color: self color.
	aCanvas line: aPoint to: aPoint + anotherPoint leftRotated width: 3 color: self color
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> drawConnectorsOn: aCanvas alignBetween: aPoint and: anotherPoint [

	| rotated |
	self connectorType = #arrow ifTrue: [
		rotated := Point r: self arrowSize degrees: (aPoint - anotherPoint) theta radiansToDegrees - 135.
		self drawArrowOn: aCanvas origin: aPoint delta: rotated].
	self connectorType = #dots ifTrue: [{aPoint. anotherPoint} do: [:point | aCanvas fillOval: (14 asPoint center: point) color: self color]]
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> drawOn: aCanvas [

	self lineType = #line ifTrue: [
		self endPointsDo: [:a :b | 
			aCanvas asBalloonCanvas
				aaLevel: 4;
				line: a to: b width: 3 color: self color.
			self drawConnectorsOn: aCanvas alignBetween: a and: b]].
	self lineType = #curve ifTrue: [ | delta controlSize controlPoint fromControl toControl points |
		points := self curvePoints.
		aCanvas asBalloonCanvas
			aaLevel: 4;
			drawBezier3Shape: points color: Color transparent borderWidth: 2 withScalingFactor borderColor: self color.
		self drawConnectorsOn: aCanvas alignBetween: points last and: points third]
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> endPointsDo: aBlock [

	^ aBlock
		value: (fromAlign = #none
			ifTrue: [from bounds line: (from bounds sideNearestTo: to center) do: [:a :b | to center nearestPointOnLineFrom: a to: b]]
			ifFalse: [from perform: (fromAlign, 'Center') asSymbol])
		value: (toAlign = #none
			ifTrue: [to bounds line: (to bounds sideNearestTo: from center) do: [:a :b | from center nearestPointOnLineFrom: a to: b]]
			ifFalse: [to perform: (toAlign, 'Center') asSymbol])
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
SBConnectorLine >> from [

	^ from
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> initialize [

	super initialize.
	lineType := #line.
	fromAlign := #none.
	toAlign := #none.
	curveModifier := 0.
	connectorType := #arrow
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> isSelfConnection [

	^ from = to
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> lineType [

	^ self isSelfConnection ifTrue: [#curve] ifFalse: [lineType]
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> lineType: aSymbol [

	lineType := aSymbol
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> outerBounds [

	^ self bounds expandBy: self arrowSize * 2
]

{ #category : #'as yet unclassified' }
SBConnectorLine >> rejectsEvent: anEvent [

	^ true
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
	(self isInWorld and: [from isInWorld not or: [to isInWorld not]]) ifTrue: [^ self delete].
	points := self lineType = #curve ifTrue: [self curvePoints] ifFalse: [self endPointsDo: [:a :b | {a. b}]].
	self bounds: (Rectangle encompassing: points)
]