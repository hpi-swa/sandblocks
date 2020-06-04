Class {
	#name : #SBNumberBaseRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBNumberBaseRepresentation class >> eagerNewFor: anObject [

	^ anObject
]

{ #category : #'as yet unclassified' }
SBNumberBaseRepresentation class >> isSmalltalkExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBNumberBaseRepresentation class >> matches: anObject [

	^ anObject isSandblock and: [anObject isNumberBlock]
]

{ #category : #'as yet unclassified' }
SBNumberBaseRepresentation class >> newFor: anObject [

	| base |
	base := ((UIManager default request: 'What base?') ifNil: [^ anObject]) asNumber.
	
	^ anObject veryDeepCopy
		contents: (base = 10 ifTrue: [''] ifFalse: [base asString, 'r']), (anObject parsedContents printStringBase: base);
		yourself
]

{ #category : #'as yet unclassified' }
SBNumberBaseRepresentation class >> priority [

	^ 8
]
