Class {
	#name : #SBScmExpressionRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmExpressionRepresentation class >> isScmExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmExpressionRepresentation class >> matches: aBlock [

	^ aBlock isSandblock and: [aBlock isScmExpression]
]

{ #category : #'as yet unclassified' }
SBScmExpressionRepresentation class >> newFor: aBlock [

	^ aBlock
]
