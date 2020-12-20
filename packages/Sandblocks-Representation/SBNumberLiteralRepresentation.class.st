Class {
	#name : #SBNumberLiteralRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBNumberLiteralRepresentation class >> isSmalltalkExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBNumberLiteralRepresentation class >> matches: anObject [

	^ anObject isNumber
]

{ #category : #'as yet unclassified' }
SBNumberLiteralRepresentation class >> newFor: anObject [

	^ SBNumber new contents: anObject asString
]

{ #category : #'as yet unclassified' }
SBNumberLiteralRepresentation class >> priority [

	^ -20
]
