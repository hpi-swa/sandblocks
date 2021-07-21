Class {
	#name : #SBCommonPalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCommonPalette class >> buildOn: aContainer [

	aContainer
		addHeader: 'Common';
		addSectionHeader: 'Waypoints';
		addBlock: 'Waypoint'
			as: (SBWaypoint new)
]

{ #category : #'as yet unclassified' }
SBCommonPalette class >> context [

	^ #()
]

{ #category : #'as yet unclassified' }
SBCommonPalette class >> grammarHandler [

	^ nil
]
