suggestions
removeSuggestionMenu

	self valueOfProperty: #sandblockSuggestionMenu ifPresentDo: #delete.
	self removeProperty: #sandblockSuggestionMenu