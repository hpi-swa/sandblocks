Class {
	#name : #SBScmToStRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmToStRepresentation class >> isScmExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmToStRepresentation class >> isSmalltalkExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmToStRepresentation class >> matches: aBlock [

	^ aBlock isSandblock and: [aBlock isScmExpression]
]

{ #category : #'as yet unclassified' }
SBScmToStRepresentation class >> newFor: aBlock [

	^ SBLanguageBox new source: aBlock sourceString
]
