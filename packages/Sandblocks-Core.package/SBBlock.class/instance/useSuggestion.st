suggestions
useSuggestion

	self suggestionMenuDo: [:menu |
		menu activeSuggestion ifNotNil: [:s | s useSuggestionOn: self]]