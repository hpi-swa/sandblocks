Class {
	#name : #SBClassMethodRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBClassMethodRepresentation class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBClassMethodRepresentation class >> isToplevelMorph [ ^ true
]

{ #category : #'as yet unclassified' }
SBClassMethodRepresentation class >> matches: anObject [
^ anObject isBehavior
]

{ #category : #'as yet unclassified' }
SBClassMethodRepresentation class >> newFor: anObject [

^ SBClassMethodEditor new class: anObject
]
