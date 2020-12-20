Class {
	#name : #SBImageMorphRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBImageMorphRepresentation class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBImageMorphRepresentation class >> isMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBImageMorphRepresentation class >> matches: anObject [

	^ anObject isForm
]

{ #category : #'as yet unclassified' }
SBImageMorphRepresentation class >> newFor: aForm [

	^ ImageMorph new image: aForm
]

{ #category : #'as yet unclassified' }
SBImageMorphRepresentation class >> priority [

	^ 11
]
