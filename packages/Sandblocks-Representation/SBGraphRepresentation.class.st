Class {
	#name : #SBGraphRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBGraphRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBGraphRepresentation class >> matches: anObject [

	true ifTrue: [^ false].
	^ anObject isCollection and: [anObject notEmpty and: [(anObject isKindOf: CompiledCode) not and: [anObject allSatisfy: #isNumber]]]
]

{ #category : #'as yet unclassified' }
SBGraphRepresentation class >> newFor: anObject [

	^ SBGraphProjection new
		object: anObject;
		yourself
]
