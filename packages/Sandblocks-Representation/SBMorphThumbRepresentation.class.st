Class {
	#name : #SBMorphThumbRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBMorphThumbRepresentation class >> isForm [

	^ true
]

{ #category : #'as yet unclassified' }
SBMorphThumbRepresentation class >> matches: anObject [

	^ anObject isMorph
]

{ #category : #'as yet unclassified' }
SBMorphThumbRepresentation class >> newFor: aMorph [

	^ aMorph thumbnail
]
