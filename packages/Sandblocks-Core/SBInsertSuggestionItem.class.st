Class {
	#name : #SBInsertSuggestionItem,
	#superclass : #SBSuggestionItem,
	#instVars : [
		'morph'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #accessing }
SBInsertSuggestionItem >> morph: aBlock editor: anEditor previewOnly: aBoolean [

	morph := aBlock.
	self preview: (aBlock wrapOffscreen: anEditor) imageForm previewOnly: aBoolean
]

{ #category : #accessing }
SBInsertSuggestionItem >> morph: aBlock previewOnly: aBoolean [

	self morph: aBlock editor: SBEditor new previewOnly: aBoolean
]

{ #category : #suggestions }
SBInsertSuggestionItem >> useSuggestionOn: aCommand in: anEditor [

	anEditor do: (aCommand morph: morph)
]

{ #category : #suggestions }
SBInsertSuggestionItem >> wouldChange: aBlock [

	^ true
]
