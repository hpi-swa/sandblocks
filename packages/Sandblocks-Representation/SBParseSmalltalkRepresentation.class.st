Class {
	#name : #SBParseSmalltalkRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBParseSmalltalkRepresentation class >> isSmalltalkExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBParseSmalltalkRepresentation class >> matches: anObject [

	(anObject isString or: [anObject isText]) ifFalse: [^ false].
	
	[anObject string parseAsNode] on: SyntaxErrorNotification do: [^ false].
	^ true
]

{ #category : #'as yet unclassified' }
SBParseSmalltalkRepresentation class >> newFor: anObject [

	^ anObject string parseAsSandblock
]
