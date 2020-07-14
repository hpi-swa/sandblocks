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
SBRepresentation class >> eagerNewFor: anObject [
	" called when eagerly evaluating representations for finding nested combinations.
	Override if eagerly evaluating will be costly or cause side effects "

	^ self newFor: anObject
]

{ #category : #'as yet unclassified' }
SBRepresentation class >> identity [

	^ false
]

{ #category : #'as yet unclassified' }
SBRepresentation class >> isLeaf [

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
SBRepresentation class >> priority [

	^ 5
]

{ #category : #'as yet unclassified' }
SBRepresentation class >> representationsDo: aBlock [

	self allSubclassesDo: aBlock.
	SBSubstitution allSubclassesDo: aBlock
]

{ #category : #'as yet unclassified' }
SBRepresentation class >> supports: aSymbol [

	^ (self respondsTo: aSymbol) and: [self perform: aSymbol]
]
