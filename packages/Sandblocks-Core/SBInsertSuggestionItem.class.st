Class {
	#name : #SBInsertSuggestionItem,
	#superclass : #SBSuggestionItem,
	#instVars : [
		'morph'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #accessing }
SBInsertSuggestionItem >> morph: aBlock previewOnly: aBoolean [

	morph := aBlock.
	self preview: aBlock imageForm previewOnly: aBoolean
]

{ #category : #suggestions }
SBInsertSuggestionItem >> useSuggestionOn: aCommand in: anEditor [

	anEditor do: (aCommand morph: morph)
]

{ #category : #suggestions }
SBInsertSuggestionItem >> wouldChange: aBlock [

	^ true
]
