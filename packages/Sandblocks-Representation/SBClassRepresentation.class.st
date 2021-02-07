Class {
	#name : #SBClassRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBClassRepresentation class >> isClassEditor [

	^ true
]

{ #category : #'as yet unclassified' }
SBClassRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBClassRepresentation class >> matches: anObject [

	^ anObject isBehavior
]

{ #category : #'as yet unclassified' }
SBClassRepresentation class >> newFor: anObject [

	^ SBClass new class: anObject
]
