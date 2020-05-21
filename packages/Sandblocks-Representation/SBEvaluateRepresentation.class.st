Class {
	#name : #SBEvaluateRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBEvaluateRepresentation class >> isObject [

	^ true
]

{ #category : #'as yet unclassified' }
SBEvaluateRepresentation class >> matches: anObject [

	^ anObject hasRepresentationThat: #isSmalltalkExpression
]

{ #category : #'as yet unclassified' }
SBEvaluateRepresentation class >> newFor: anObject [

	^ [anObject evaluate] on: Error do: [nil]
]
