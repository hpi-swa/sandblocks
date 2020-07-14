Class {
	#name : #SBObjectRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBObjectRepresentation class >> catchesAll [

	^ true
]

{ #category : #'as yet unclassified' }
SBObjectRepresentation class >> identity [

	^ true
]

{ #category : #'as yet unclassified' }
SBObjectRepresentation class >> isObject [

	^ true
]

{ #category : #'as yet unclassified' }
SBObjectRepresentation class >> matches: anObject [

	^ true
]

{ #category : #'as yet unclassified' }
SBObjectRepresentation class >> newFor: anObject [

	^ anObject
]
