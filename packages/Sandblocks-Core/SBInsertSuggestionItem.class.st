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
	self
		preview: (anEditor ifNotNil: [aBlock wrapOffscreen: anEditor] ifNil: [
			SBSelection new
				addMorphBack: aBlock;
				colorPolicy: SBEditor defaultColorPolicy new]) imageForm
		previewOnly: aBoolean
]

{ #category : #accessing }
SBInsertSuggestionItem >> morph: aBlock previewOnly: aBoolean [

	self morph: aBlock editor: nil previewOnly: aBoolean
]

{ #category : #suggestions }
SBInsertSuggestionItem >> useSuggestionOn: aCommand in: anEditor [

	anEditor do: (aCommand morph: morph)
]

{ #category : #suggestions }
SBInsertSuggestionItem >> wouldChange: aBlock [

	^ true
]
