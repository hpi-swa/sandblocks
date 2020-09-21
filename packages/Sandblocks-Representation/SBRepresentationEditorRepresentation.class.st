Class {
	#name : #SBRepresentationEditorRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBRepresentationEditorRepresentation class >> isToplevelMorph [ ^ true
]

{ #category : #'as yet unclassified' }
SBRepresentationEditorRepresentation class >> matches: anObject [

	^ anObject isBehavior and: [anObject inheritsFrom: SBRepresentation]
]

{ #category : #'as yet unclassified' }
SBRepresentationEditorRepresentation class >> newFor: anObject [

^ SBRepresentationEditor new class: anObject
]
