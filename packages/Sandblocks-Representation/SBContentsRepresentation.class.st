Class {
	#name : #SBContentsRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBContentsRepresentation class >> matches: anObject [

	^ (anObject respondsTo: #contents) and: [anObject isText not and: [anObject contents isString or: [anObject contents isText]]]
]

{ #category : #'as yet unclassified' }
SBContentsRepresentation class >> newFor: anObject [

	^ anObject contents string
]
