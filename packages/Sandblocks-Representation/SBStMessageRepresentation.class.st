Class {
	#name : #SBStMessageRepresentation,
	#superclass : #SBStExpressionRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBStMessageRepresentation class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBStMessageRepresentation class >> isSmalltalkMessage [

	^ true
]

{ #category : #'as yet unclassified' }
SBStMessageRepresentation class >> matches: anObject [

	^ (super matches: anObject) and: [anObject isMessageSend]
]

{ #category : #'as yet unclassified' }
SBStMessageRepresentation class >> priority [

	^ 4
]
