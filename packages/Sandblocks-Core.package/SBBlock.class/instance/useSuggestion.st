actions
useSuggestion
	<inputAction>
	<actionValidIf: #hasSuggestions>
	" try to apply a suggestion, return whether anything was applied "

	self suggestionMenuDo: [:menu | | editor |
		editor := self sandblockEditor.
		menu activeSuggestion ifNotNil: [:s | s useSuggestionOn: self].
		editor maybeStartInputFromEnd.
		^ true].
	^ false