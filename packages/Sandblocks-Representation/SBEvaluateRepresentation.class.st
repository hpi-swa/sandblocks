Class {
	#name : #SBEvaluateRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBEvaluateRepresentation class >> eagerNewFor: anObject [

	^ Object new
]

{ #category : #'as yet unclassified' }
SBEvaluateRepresentation class >> isObject [

	^ true
]

{ #category : #'as yet unclassified' }
SBEvaluateRepresentation class >> matches: anObject [

	^ anObject hasDerivableRepresentationThat: #isSmalltalkExpression
]

{ #category : #'as yet unclassified' }
SBEvaluateRepresentation class >> newFor: anObject [

	^ anObject evaluate
]
