Class {
	#name : #SBStringViewRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Format'
}

{ #category : #'as yet unclassified' }
SBStringViewRepresentation class >> isMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBStringViewRepresentation class >> isSandblock [

	^ true
]

{ #category : #'as yet unclassified' }
SBStringViewRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBStringViewRepresentation class >> matches: anObject [

	^ anObject isString
]

{ #category : #'as yet unclassified' }
SBStringViewRepresentation class >> newFor: anObject [

	^ SBStringView new string: anObject
]
