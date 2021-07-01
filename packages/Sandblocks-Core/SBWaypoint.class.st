Class {
	#name : #SBWaypoint,
	#superclass : #SBBlock,
	#instVars : [
		'targets',
		'labelBlock'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBWaypoint >> initialize [

	super initialize.
	self
		targets: Set new;
		labelBlock: SBPlainTextBlock new;
		addMorph: self labelBlock;
		addMorph: SBIcon iconFlag veryLarge;
		attachDecorator: SBWaypointMoveDecorator new;
		changeTableLayout;
		listCentering: #centering;
		wrapCentering: #centering;
		cellPositioning: #center;
		cellGap: 8;
		layoutInset: 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap.
	
	self labelBlock contents: 'Waypoint'
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
SBWaypoint >> wasDeselected [ 
	
	super wasDeselected 
]

{ #category : #'as yet unclassified' }
SBWaypoint >> wasSelected [ 
	
	super wasSelected 
]
