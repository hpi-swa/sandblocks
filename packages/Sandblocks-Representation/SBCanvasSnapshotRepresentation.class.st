Class {
	#name : #SBCanvasSnapshotRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBCanvasSnapshotRepresentation class >> matches: anObject [

	^ anObject isKindOf: FormCanvas
]

{ #category : #'as yet unclassified' }
SBCanvasSnapshotRepresentation class >> newFor: aCanvas [

	^ aCanvas form copy
]
