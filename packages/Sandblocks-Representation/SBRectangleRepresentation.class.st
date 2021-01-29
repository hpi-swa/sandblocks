Class {
	#name : #SBRectangleRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBRectangleRepresentation class >> isSmalltalkExpression [ ^ true
]

{ #category : #'as yet unclassified' }
SBRectangleRepresentation class >> matches: anObject [

	^ anObject satisfies: {
		[:s | false].
		#isSandblock.
		#isMessageSend.
		[:send | #(#extent: #corner:) includes: send selector].
		[:send | send arguments size = 1].
		[:send | SBPoint matches: send receiver].
		[:send | SBPoint matches: send arguments first]
	}
]

{ #category : #'as yet unclassified' }
SBRectangleRepresentation class >> newFor: anObject [

^ SBRectangle new
]
