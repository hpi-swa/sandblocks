Class {
	#name : #SBInsertSuggestionItem,
	#superclass : #SBSuggestionItem,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBInsertSuggestionItem >> useSuggestionOn: aCommand in: anEditor [

	anEditor do: aCommand
]

{ #category : #'as yet unclassified' }
SBInsertSuggestionItem >> wouldChange: aBlock [

	^ true
]
