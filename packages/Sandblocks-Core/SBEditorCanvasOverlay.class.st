Class {
	#name : #SBEditorCanvasOverlay,
	#superclass : #Morph,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBEditorCanvasOverlay >> rejectsEvent: anEvent [
	
	^ self submorphs allSatisfy: [:aMorph | aMorph rejectsEvent: anEvent]
]

{ #category : #'as yet unclassified' }
SBEditorCanvasOverlay >> wantsHalo [
	
	^ false
]

{ #category : #'as yet unclassified' }
SBEditorCanvasOverlay >> wantsHaloFromClick [ 
	
	^ false
]
