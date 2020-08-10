Class {
	#name : #SBPlaygroundRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBPlaygroundRepresentation class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBPlaygroundRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBPlaygroundRepresentation class >> matches: anObject [

	^ "anObject hasRepresentationThat: #isSmalltalkExpression" anObject isSandblock and: [anObject isASTNode]
]

{ #category : #'as yet unclassified' }
SBPlaygroundRepresentation class >> newFor: anObject [

	^ SBRepl new statements: {anObject veryDeepCopy}
]

{ #category : #'as yet unclassified' }
SBPlaygroundRepresentation class >> priority [

	^ 2
]
