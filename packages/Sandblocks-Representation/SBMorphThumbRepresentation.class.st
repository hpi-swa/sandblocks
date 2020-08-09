Class {
	#name : #SBMorphThumbRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBMorphThumbRepresentation class >> eagerNewFor: aMorph [

	" be conservative with our resources "
	^ Form basicNew
]

{ #category : #'as yet unclassified' }
SBMorphThumbRepresentation class >> isForm [

	^ true
]

{ #category : #'as yet unclassified' }
SBMorphThumbRepresentation class >> matches: anObject [

	^ anObject isMorph and: [anObject isSandblock not]
]

{ #category : #'as yet unclassified' }
SBMorphThumbRepresentation class >> newFor: aMorph [

	^ aMorph thumbnail
]
