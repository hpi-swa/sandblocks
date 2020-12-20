Class {
	#name : #SBMethodRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBMethodRepresentation class >> isMethod [

	^ true
]

{ #category : #'as yet unclassified' }
SBMethodRepresentation class >> isMethodBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBMethodRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBMethodRepresentation class >> matches: anObject [

	^ anObject isCompiledMethod
]

{ #category : #'as yet unclassified' }
SBMethodRepresentation class >> newFor: anObject [

	^ anObject asSandblock
]
