Class {
	#name : #SBRepresentationEditorEditorRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBRepresentationEditorEditorRepresentation class >> isToplevelMorph [ ^ true
]

{ #category : #'as yet unclassified' }
SBRepresentationEditorEditorRepresentation class >> matches: anObject [

	^ anObject isBehavior and: [anObject inheritsFrom: SBRepresentation]
]

{ #category : #'as yet unclassified' }
SBRepresentationEditorEditorRepresentation class >> newFor: anObject [

^ SBRepresentationEditor new class: anObject
]

{ #category : #'as yet unclassified' }
SBRepresentationEditorEditorRepresentation class >> priority [

	^ 10
]
