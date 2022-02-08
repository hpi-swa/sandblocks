Class {
	#name : #SBBlockSuggestionItem,
	#superclass : #SBSuggestionItem,
	#instVars : [
		'builder'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBlockSuggestionItem >> builder: aBlockClosure [
	
	builder := aBlockClosure
]

{ #category : #'as yet unclassified' }
SBBlockSuggestionItem >> useSuggestionOn: aBlock in: anEditor [

	anEditor do: (SBReplaceCommand new
		target: aBlock
		replacer: builder value)
]
