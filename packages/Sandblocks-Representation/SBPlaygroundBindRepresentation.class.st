Class {
	#name : #SBPlaygroundBindRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBPlaygroundBindRepresentation class >> catchesAll [

	^ true
]

{ #category : #'as yet unclassified' }
SBPlaygroundBindRepresentation class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBPlaygroundBindRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBPlaygroundBindRepresentation class >> matches: anObject [

	^ true
]

{ #category : #'as yet unclassified' }
SBPlaygroundBindRepresentation class >> newFor: anObject [

	^ SBRepl new receiver: anObject; statements: {SBName contents: 'self'}
]

{ #category : #'as yet unclassified' }
SBPlaygroundBindRepresentation class >> priority [

	^ 1
]
