Class {
	#name : #SBStExpressionRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBStExpressionRepresentation class >> identity [

	^ true
]

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

	self flag: #todo. " find a proper way for this. problem:
	- deep copy is generally better, but we want the representation as ast nodes, even if we're a projection 
	- #sourceString produces errors when unknowns are in the expression
	"
	^ (anObject isKindOf: SBSubstitution)
		ifTrue: [anObject sourceString parseAsSandblockWithoutSubstitution]
		ifFalse: [anObject veryDeepCopy]
]
