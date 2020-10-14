Class {
	#name : #SBScaledFormRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBScaledFormRepresentation class >> isForm [ ^ true
]

{ #category : #'as yet unclassified' }
SBScaledFormRepresentation class >> matches: anObject [
^ anObject isForm
]

{ #category : #'as yet unclassified' }
SBScaledFormRepresentation class >> newFor: anObject [

^ anObject scaledIntoFormOfSize: 100 @ 100
]
