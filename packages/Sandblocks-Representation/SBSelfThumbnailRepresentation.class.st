Class {
	#name : #SBSelfThumbnailRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBSelfThumbnailRepresentation class >> isSmalltalkExpression [ ^ true
]

{ #category : #'as yet unclassified' }
SBSelfThumbnailRepresentation class >> matches: anObject [

	^ (anObject isKindOf: SBSelfThumbnail) or: [
		anObject satisfies: {
			#isSandblock.
			#isName.
			[:o | o contents = 'self'].
			[:o |
				o containingArtefact satisfies: {
					#notNil.
					[:a | a containingArtefact evaluationReceiver isMorph].
					[:a | a evaluationReceiver bounds notNil]}]
		}]
]

{ #category : #'as yet unclassified' }
SBSelfThumbnailRepresentation class >> newFor: anObject [

^ SBSelfThumbnail new object: anObject containingArtefact evaluationReceiver
]
