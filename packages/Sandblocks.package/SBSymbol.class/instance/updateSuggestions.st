as yet unclassified
updateSuggestions

	| suggestions |
	suggestions := self contents
		ifEmpty: [#()]
		ifNotEmpty: [:text | (self completionSuggestionsFor: text) collect: [:sel | SBSuggestionItem selector: sel label: 'symbol']].
	self updateSuggestions: suggestions showNear: self