Class {
	#name : #SBExtractFieldRepresentation,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBExtractFieldRepresentation >> causesSideEffects [

	^ false
]

{ #category : #'as yet unclassified' }
SBExtractFieldRepresentation >> eagerNewFor: anObject [

	^ self newFor: anObject
]

{ #category : #'as yet unclassified' }
SBExtractFieldRepresentation >> identity [

	^ false
]

{ #category : #'as yet unclassified' }
SBExtractFieldRepresentation >> isLeaf [

	^ false
]

{ #category : #'as yet unclassified' }
SBExtractFieldRepresentation >> matches: anObject [

	" we only enter this path from SBRepresentation>>representationsDo:for: if we have matched "
	^ true
]

{ #category : #'as yet unclassified' }
SBExtractFieldRepresentation >> name: aSymbol [

	name := aSymbol
]

{ #category : #'as yet unclassified' }
SBExtractFieldRepresentation >> newFor: anObject [

	^ (Smalltalk at: #Sandbox) ifNotNil: [:sandboxClass | sandboxClass evaluate: [anObject perform: name]]
]

{ #category : #'as yet unclassified' }
SBExtractFieldRepresentation >> prettyName [

	^ '(', name, ')'
]

{ #category : #'as yet unclassified' }
SBExtractFieldRepresentation >> priority [

	^ -1
]

{ #category : #'as yet unclassified' }
SBExtractFieldRepresentation >> supports: aSymbol [

	^ false
]
