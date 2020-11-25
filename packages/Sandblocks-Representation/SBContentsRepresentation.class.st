Class {
	#name : #SBContentsRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBContentsRepresentation class >> matches: anObject [

	| contents |
	(anObject respondsTo: #contents) ifFalse: [^ false].
	contents := [anObject contents] on: Error do: [^ false].
	^ anObject isText not and: [contents isString or: [anObject contents isText]]
]

{ #category : #'as yet unclassified' }
SBContentsRepresentation class >> newFor: anObject [

	^ anObject contents string
]
