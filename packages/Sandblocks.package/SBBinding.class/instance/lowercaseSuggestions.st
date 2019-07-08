as yet unclassified
lowercaseSuggestions

	| block method |
	block := self containingBlock.
	method := self containingMethod.
	
	^ (block temporaries select: [:v | v contents sandblockMatch: self contents] thenCollect: [:v | SBSuggestionItem selector: v contents label: 'temporary']),
		(block bindings select: [:v | v contents sandblockMatch: self contents] thenCollect: [:v | SBSuggestionItem selector: v contents label: 'block var']),
		(method arguments select: [:v | v contents sandblockMatch: self contents] thenCollect: [:v | SBSuggestionItem selector: v contents label: 'argument']),
		(method instanceVariables select: [:v | v contents sandblockMatch: self contents] thenCollect: [:v | SBSuggestionItem selector: v contents label: 'instance'])