suggestions
useSuggestion
	" try to apply a suggestion, return whether anything was applied "

	self suggestionMenuDo: [:menu |
		menu activeSuggestion ifNotNil: [:s | s useSuggestionOn: self].
		^ true].
	^ false