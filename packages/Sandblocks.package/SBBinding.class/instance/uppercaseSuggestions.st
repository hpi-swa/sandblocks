as yet unclassified
uppercaseSuggestions

	self flag: #todo. "pool dict etc"
	^ Smalltalk classNames
		select: [:cls | cls sandblockMatch: self contents]
		thenCollect: [:cls | SBSuggestionItem selector: cls label: 'class']