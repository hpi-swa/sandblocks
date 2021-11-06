Class {
	#name : #SBJsExpressionRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsExpressionRepresentation class >> isJsExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsExpressionRepresentation class >> matches: aBlock [

	^ aBlock isSandblock and: [aBlock isJsExpression]
]

{ #category : #'as yet unclassified' }
SBJsExpressionRepresentation class >> newFor: aBlock [

	^ aBlock veryDeepCopy
]
