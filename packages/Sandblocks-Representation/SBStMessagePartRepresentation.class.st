Class {
	#name : #SBStMessagePartRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBStMessagePartRepresentation class >> isSmalltalkMessagePart [

	^ true
]

{ #category : #'as yet unclassified' }
SBStMessagePartRepresentation class >> matches: anObject [

	^ "anObject isSandblock and: [anObject isName]"anObject isString
]

{ #category : #'as yet unclassified' }
SBStMessagePartRepresentation class >> newFor: anObject [

	^ SBStMessagePart new contents: anObject
]
