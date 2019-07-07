as yet unclassified
suggestions: aCollectionOfSymbol

	self removeAllMorphs.
	
	aCollectionOfSymbol do: [:selector |
		self addMorphBack: (SBSuggestionItem new selector: selector)].
	
	self hasSubmorphs ifTrue: [
		activeIndex := activeIndex min: self submorphCount.
		(self submorphs at: activeIndex) active: true]