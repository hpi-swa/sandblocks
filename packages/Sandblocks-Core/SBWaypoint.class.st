Class {
	#name : #SBWaypoint,
	#superclass : #SBBlock,
	#instVars : [
		'targets',
		'labelBlock',
		'counterMorph'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBWaypoint >> counterMorph [

	^ counterMorph
]

{ #category : #'as yet unclassified' }
SBWaypoint >> counterMorph: aMorph [

	counterMorph := aMorph
]

{ #category : #'as yet unclassified' }
SBWaypoint >> example [

	SBMorphExample
		setUp: [SBWaypoint new]
		cases: {SBMorphExampleCase name: 'example 1' caseBlock: [:m | m]}
		extent: 300 @ 300
]

{ #category : #'as yet unclassified' }
SBWaypoint >> initialize [

	super initialize.
	self
		targets: Set new;
		labelBlock: SBPlainTextBlock new;
		counterMorph: SBStringMorph new;
		addMorph: self labelBlock;
		addMorph: (SBRow new
			addMorph: self counterMorph;
			addMorph: SBIcon iconFlag veryLarge;
			changeTableLayout;
			cellGap: 8);
		attachDecorator: SBWaypointMoveDecorator new;
		changeTableLayout;
		cellPositioning: #center;
		cellGap: 8;
		layoutInset: 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap.
	
	self labelBlock contents: 'Waypoint'.
	self counterMorph contents: '0'
]

{ #category : #'as yet unclassified' }
SBWaypoint >> isAttractedTo: aBlock [
	
	^ false
]

{ #category : #accessing }
SBWaypoint >> labelBlock [

	^ labelBlock
]

{ #category : #accessing }
SBWaypoint >> labelBlock: anObject [

	labelBlock := anObject.
]

{ #category : #accessing }
SBWaypoint >> targets [

	^ targets
]

{ #category : #accessing }
SBWaypoint >> targets: anObject [

	targets := anObject.
]

{ #category : #'as yet unclassified' }
SBWaypoint >> textContents [ 
	
	^ self labelBlock contents 
]

{ #category : #'as yet unclassified' }
SBWaypoint >> toggleTarget: aWaypoint [

	self targets remove: aWaypoint ifAbsent: [self targets add: aWaypoint].
	self counterMorph contents: self targets size asString
]

{ #category : #'as yet unclassified' }
SBWaypoint >> wasDeselected [ 
	
	super wasDeselected 
]

{ #category : #'as yet unclassified' }
SBWaypoint >> wasSelected [ 
	
	super wasSelected 
]
