Class {
	#name : #SBStExpressionRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBStExpressionRepresentation class >> isSmalltalkExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBStExpressionRepresentation class >> matches: anObject [

	self flag: #todo. " incorrect to assume that these are sandblocks, but currently practical "
	^ anObject isSandblock and: [anObject isExpression]
]

{ #category : #'as yet unclassified' }
SBStExpressionRepresentation class >> newFor: anObject [

	^ anObject sourceString parseAsSandblockWithoutSubstitution
]
