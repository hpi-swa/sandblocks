Class {
	#name : #SBRepresentationAggregateRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBRepresentationAggregateRepresentation class >> causesSideEffects [

	^ true
]

{ #category : #'as yet unclassified' }
SBRepresentationAggregateRepresentation class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBRepresentationAggregateRepresentation class >> isToplevelMorph [ ^ true
]

{ #category : #'as yet unclassified' }
SBRepresentationAggregateRepresentation class >> matches: anObject [
^ true
]

{ #category : #'as yet unclassified' }
SBRepresentationAggregateRepresentation class >> newFor: anObject [

^ SBRepresentationAggregate new replace: anObject
]
