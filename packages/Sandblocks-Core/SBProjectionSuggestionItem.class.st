Class {
	#name : #SBProjectionSuggestionItem,
	#superclass : #SBSuggestionItem,
	#category : #'Sandblocks-Core'
}

{ #category : #accessing }
SBProjectionSuggestionItem >> instanceSuggestion: aFactoryClosure editor: anEditor [

	| example |
	aFactoryClosure ifNil: [^ self].
	
	example := aFactoryClosure value.
	example extent: example minExtent.
	
	" provides styling information to its children "
	anEditor newSelectionContainer
		addMorphBack: example;
		yourself.
	
	self preview: example imageForm previewOnly: false
]
