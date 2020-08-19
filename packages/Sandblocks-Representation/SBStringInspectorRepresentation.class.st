Class {
	#name : #SBStringInspectorRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBStringInspectorRepresentation class >> isMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBStringInspectorRepresentation class >> isSandblock [

	^ true
]

{ #category : #'as yet unclassified' }
SBStringInspectorRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBStringInspectorRepresentation class >> matches: anObject [

	^ anObject isString
]

{ #category : #'as yet unclassified' }
SBStringInspectorRepresentation class >> newFor: anObject [

	^ SBStringView new string: anObject
]
