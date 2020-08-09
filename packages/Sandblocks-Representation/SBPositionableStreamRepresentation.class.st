Class {
	#name : #SBPositionableStreamRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBPositionableStreamRepresentation class >> isSandblock [

	^ true
]

{ #category : #'as yet unclassified' }
SBPositionableStreamRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBPositionableStreamRepresentation class >> matches: anObject [

	^ anObject isKindOf: PositionableStream
]

{ #category : #'as yet unclassified' }
SBPositionableStreamRepresentation class >> newFor: aStream [

	^ SBPositionableStreamView new stream: aStream
]
