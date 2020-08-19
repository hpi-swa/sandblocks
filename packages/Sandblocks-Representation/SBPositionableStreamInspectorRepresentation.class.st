Class {
	#name : #SBPositionableStreamInspectorRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBPositionableStreamInspectorRepresentation class >> isSandblock [

	^ true
]

{ #category : #'as yet unclassified' }
SBPositionableStreamInspectorRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBPositionableStreamInspectorRepresentation class >> matches: anObject [

	^ anObject isKindOf: PositionableStream
]

{ #category : #'as yet unclassified' }
SBPositionableStreamInspectorRepresentation class >> newFor: aStream [

	^ SBPositionableStreamView new stream: aStream
]
