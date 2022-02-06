Class {
	#name : #SBStLiteralSuggestionItem,
	#superclass : #SBSuggestionItem,
	#instVars : [
		'literal'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStLiteralSuggestionItem >> literal: anObject [

	self selector: anObject storeString label: 'literal'.
	literal := anObject
]

{ #category : #'as yet unclassified' }
SBStLiteralSuggestionItem >> useSuggestionOn: aBlock in: anEditor [

	anEditor do: (SBReplaceCommand new
		target: aBlock
		replacer: (LiteralNode sandblockForLiteral: literal))
]
