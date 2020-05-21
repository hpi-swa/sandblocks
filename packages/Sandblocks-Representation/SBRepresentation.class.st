Class {
	#name : #SBRepresentation,
	#superclass : #Object,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBRepresentation class >> catchesAll [

	^ false
]

{ #category : #'as yet unclassified' }
SBRepresentation class >> matches: anObject [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBRepresentation class >> newFor: anObject [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBRepresentation class >> prettyName [

	^ self name copyFrom: 3 to: self name size - 'Representation' size
]

{ #category : #'as yet unclassified' }
SBRepresentation class >> supports: aSymbol [

	^ (self respondsTo: aSymbol) and: [self perform: aSymbol]
]
