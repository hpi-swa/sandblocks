Class {
	#name : #SBOpenBlockRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBOpenBlockRepresentation class >> causesSideEffects [

	^ true
]

{ #category : #'as yet unclassified' }
SBOpenBlockRepresentation class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBOpenBlockRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBOpenBlockRepresentation class >> matches: anObject [
^ anObject isSandblock
]

{ #category : #'as yet unclassified' }
SBOpenBlockRepresentation class >> newFor: anObject [

^ anObject
]
