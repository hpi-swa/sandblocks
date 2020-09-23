Class {
	#name : #SBOpenClassRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBOpenClassRepresentation class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBOpenClassRepresentation class >> isToplevelMorph [ ^ true
]

{ #category : #'as yet unclassified' }
SBOpenClassRepresentation class >> matches: anObject [
^ true
]

{ #category : #'as yet unclassified' }
SBOpenClassRepresentation class >> newFor: anObject [

^ SBClassMethodEditor new class: anObject class
]

{ #category : #'as yet unclassified' }
SBOpenClassRepresentation class >> priority [

	^ 1
]
