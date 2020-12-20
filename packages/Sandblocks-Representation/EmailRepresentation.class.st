Class {
	#name : #EmailRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
EmailRepresentation class >> isEmail [ ^ true
]

{ #category : #'as yet unclassified' }
EmailRepresentation class >> matches: anObject [

	^ anObject isString and: [anObject matchesRegex: '.+@.+']
]

{ #category : #'as yet unclassified' }
EmailRepresentation class >> newFor: anObject [

^ anObject
]
