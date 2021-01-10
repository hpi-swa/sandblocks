Class {
	#name : #SBScmModuleRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmModuleRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmModuleRepresentation class >> matches: aBlock [

	^ aBlock isSandblock and: [aBlock isScmExpression]
]

{ #category : #'as yet unclassified' }
SBScmModuleRepresentation class >> newFor: aBlock [

	^ SBScmModule new removeAllMorphs; addMorphBack: aBlock
]
