Class {
	#name : #SBPlainTextRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBPlainTextRepresentation class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBPlainTextRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBPlainTextRepresentation class >> matches: aBlock [

	^ aBlock isSandblock and: [aBlock isStringBlock]
]

{ #category : #'as yet unclassified' }
SBPlainTextRepresentation class >> newFor: aBlock [

	^ SBPlainTextBlock new contents: aBlock contents
]
