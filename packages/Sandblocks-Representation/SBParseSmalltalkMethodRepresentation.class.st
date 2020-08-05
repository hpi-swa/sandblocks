Class {
	#name : #SBParseSmalltalkMethodRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBParseSmalltalkMethodRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBParseSmalltalkMethodRepresentation class >> matches: anObject [

	(anObject isString or: [anObject isText]) ifFalse: [^ false].
	
	[anObject string parseAsMethod] on: SyntaxErrorNotification do: [^ false].
	^ true
]

{ #category : #'as yet unclassified' }
SBParseSmalltalkMethodRepresentation class >> newFor: anObject [

	^ anObject string parseAsMethod asSandblock
]
