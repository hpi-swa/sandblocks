Class {
	#name : #SBConnector,
	#superclass : #Morph,
	#instVars : [
		'source',
		'destination'
	],
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBConnector >> connectFrom: aSource to: aDestination [

	self connect: aSource node signal: #positionChanged: toSelector: #updateConnection.
	self connect: aDestination node signal: #positionChanged: toSelector: #updateConnection.
	
	aSource socket notifyConnectTo: self.
	aDestination socket notifyConnectTo: self.
	
	source := aSource socket.
	destination := aDestination socket.
	
	self updateConnection
]

{ #category : #'as yet unclassified' }
SBConnector >> delete [

	source notifyDisconnectFrom: self.
	destination notifyDisconnectFrom: self.
	
	super delete
]

{ #category : #'as yet unclassified' }
SBConnector >> drawOn: aCanvas [

	"aCanvas line: source center to: destination center width: 2 * self scalingFactor color: Color black"
	(source type = #flowIn or: [source type = #flowOut])
		ifTrue: [ | controlHeight |
			controlHeight := (destination left - source left * 0.5) abs.
			aCanvas asBalloonCanvas
				aaLevel: 4;
				drawBezier3Shape: {
					source center.
					source center + (0 @ controlHeight * (source type = #flowIn ifTrue: [-1] ifFalse: [1])).
					destination center + (0 @ controlHeight * (destination type = #flowIn ifTrue: [-1] ifFalse: [1])).
					destination center}
				color: Color transparent
				borderWidth: 2 * self scalingFactor
				borderColor: Color red]
		ifFalse: [ | controlWidth |
			controlWidth := (destination left - source left * 0.5) abs.
			aCanvas asBalloonCanvas
				drawBezier3Shape: {
					source center.
					source center + (controlWidth @ 0 * (source type = #input ifTrue: [-1] ifFalse: [1])).
					destination center + (controlWidth @ 0 * (destination type = #input ifTrue: [-1] ifFalse: [1])).
					destination center}
				color: Color transparent
				borderWidth: 2 * self scalingFactor
				borderColor: Color black]
]

{ #category : #'as yet unclassified' }
SBConnector >> end: aPoint [

	destination := aPoint
	"self verticesAt: 2 put: aPoint"
]

{ #category : #'as yet unclassified' }
SBConnector >> handlesMouseMove: anEvent [

	^ false
]

{ #category : #'as yet unclassified' }
SBConnector >> isLink [

	^ true
]

{ #category : #'as yet unclassified' }
SBConnector >> isNode [

	^ false
]

{ #category : #'as yet unclassified' }
SBConnector >> mouseMove: anEvent [

	self verticesAt: 2 put: anEvent position
]

{ #category : #'as yet unclassified' }
SBConnector >> mouseUp: anEvent [

	self delete
]

{ #category : #'as yet unclassified' }
SBConnector >> outerBounds [

	^ self bounds expandBy: 20 * self scalingFactor
]

{ #category : #'as yet unclassified' }
SBConnector >> rejectsEvent: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBConnector >> source [

	^ source
]

{ #category : #'as yet unclassified' }
SBConnector >> sourceNode [

	^ source node
]

{ #category : #'as yet unclassified' }
SBConnector >> start: aPoint [

	"self verticesAt: 1 put: aPoint"
]

{ #category : #'as yet unclassified' }
SBConnector >> startNow: aPoint [

	source := aPoint
	"self vertices: {aPoint. aPoint} color: Color black borderWidth: 2 * self scalingFactor borderColor: Color black"
]

{ #category : #'as yet unclassified' }
SBConnector >> target [

	^ destination
]

{ #category : #'as yet unclassified' }
SBConnector >> targetNode [

	^ destination node
]

{ #category : #'as yet unclassified' }
SBConnector >> updateConnection [

	self bounds: (Rectangle encompassing: {source center. destination center})
	"self start: source center.
	self end: destination center"
]
