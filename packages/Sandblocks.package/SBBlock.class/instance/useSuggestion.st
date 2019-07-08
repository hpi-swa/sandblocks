suggestions
useSuggestion

	self suggestionMenuDo: [:menu |
		menu activeSelector ifNotNil: [:s | self useSuggestion: s]]