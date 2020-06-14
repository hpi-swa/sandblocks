Class {
	#name : #SBFormProjection,
	#superclass : #SBDataProjection,
	#category : #'Sandblocks-Explorer'
}

{ #category : #'as yet unclassified' }
SBFormProjection class >> matches: anObject [

	^ anObject isForm
]

{ #category : #'as yet unclassified' }
SBFormProjection >> childSandblocksDo: aBlock [

	
]

{ #category : #'as yet unclassified' }
SBFormProjection >> initialize [

	super initialize.
	self
		changeTableLayout;
		addMorph: ImageMorph new;
		layoutInset: 4 withScalingFactor
]

{ #category : #'as yet unclassified' }
SBFormProjection >> object: anObject [

	self firstSubmorph image: anObject
]
