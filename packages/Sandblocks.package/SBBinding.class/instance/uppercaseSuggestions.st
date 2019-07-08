as yet unclassified
uppercaseSuggestions

	^ Smalltalk classNames
		select: [:cls | cls sandblockMatch: self contents]
		thenCollect: [:cls | SBSuggestionItem selector: cls label: 'class']