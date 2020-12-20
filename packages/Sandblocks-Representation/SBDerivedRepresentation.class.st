Class {
	#name : #SBDerivedRepresentation,
	#superclass : #Object,
	#instVars : [
		'from',
		'to'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBDerivedRepresentation class >> from: aRepr to: anotherRepr [

	^ self new
		from: aRepr;
		to: anotherRepr;
		yourself
]

{ #category : #'as yet unclassified' }
SBDerivedRepresentation >> = aRepr [

	^ aRepr class = self class and: [self from = aRepr from and: [self to = aRepr to]]
]

{ #category : #'as yet unclassified' }
SBDerivedRepresentation >> causesSideEffects [

	^ from causesSideEffects or: [to causesSideEffects]
]

{ #category : #'as yet unclassified' }
SBDerivedRepresentation >> from [

	^ from
]

{ #category : #'as yet unclassified' }
SBDerivedRepresentation >> from: anObject [

	from := anObject
]

{ #category : #'as yet unclassified' }
SBDerivedRepresentation >> hash [

	^ from hash bitXor: to hash
]

{ #category : #'as yet unclassified' }
SBDerivedRepresentation >> matches: anObject [

	^ from matches: anObject
]

{ #category : #'as yet unclassified' }
SBDerivedRepresentation >> newFor: anObject [

	^ to newFor: (from newFor: anObject)
]

{ #category : #'as yet unclassified' }
SBDerivedRepresentation >> prettyName [

	^ '{1} -> {2}' format: {self from prettyName. self to prettyName}
]

{ #category : #'as yet unclassified' }
SBDerivedRepresentation >> printOn: aStream [

	aStream nextPutAll: self prettyName
]

{ #category : #'as yet unclassified' }
SBDerivedRepresentation >> priority [

	^ (from priority min: to priority) - 0.5
]

{ #category : #'as yet unclassified' }
SBDerivedRepresentation >> to [

	^ to
]

{ #category : #'as yet unclassified' }
SBDerivedRepresentation >> to: anObject [

	to := anObject
]
