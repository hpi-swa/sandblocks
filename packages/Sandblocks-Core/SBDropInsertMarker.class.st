Class {
	#name : #SBDropInsertMarker,
	#superclass : #Morph,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDropInsertMarker class >> markerColor [

	^ Color r: 0.942 g: 0.968 b: 0.627
]

{ #category : #'as yet unclassified' }
SBDropInsertMarker >> initialize [

	super initialize.
	
	self color: self class markerColor
]

{ #category : #'as yet unclassified' }
SBDropInsertMarker >> rejectsEvent: anEvent [

	^ true
]
