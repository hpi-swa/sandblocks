Class {
	#name : #SBLabelRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBLabelRepresentation class >> catchesAll [

	^ 0
]

{ #category : #'as yet unclassified' }
SBLabelRepresentation class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBLabelRepresentation class >> isMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBLabelRepresentation class >> matches: anObject [

	^ true
]

{ #category : #'as yet unclassified' }
SBLabelRepresentation class >> newFor: anObject [

	^ SBStringMorph new contents: (anObject printStringLimitedTo: 120)
]

{ #category : #'as yet unclassified' }
SBLabelRepresentation class >> priority [

	^ 10
]
