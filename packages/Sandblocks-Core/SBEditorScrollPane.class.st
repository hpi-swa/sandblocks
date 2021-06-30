Class {
	#name : #SBEditorScrollPane,
	#superclass : #ScrollPane,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBEditorScrollPane >> click: evt [

	self sandblockEditor click: evt
]

{ #category : #'as yet unclassified' }
SBEditorScrollPane >> mouseDown: anEvent [

	anEvent hand waitForClicksOrDrag: self event: anEvent
]
