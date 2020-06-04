Class {
	#name : #SBStNameRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBStNameRepresentation class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNameRepresentation class >> isSmalltalkExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNameRepresentation class >> isSmalltalkName [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNameRepresentation class >> matches: aBlock [

	^ (aBlock respondsTo: #contents) and: [aBlock contents isString  and: [aBlock contents isEmpty or: [aBlock contents first isLetter and: [aBlock contents viewAllButFirst allSatisfy: #isAlphaNumeric]]]]
]

{ #category : #'as yet unclassified' }
SBStNameRepresentation class >> newFor: anObject [

	^ SBName contents: anObject contents
]

{ #category : #'as yet unclassified' }
SBStNameRepresentation class >> priority [

	^ 0
]
