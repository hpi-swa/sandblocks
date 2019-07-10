as yet unclassified
updateSuggestions

	| selector |
	self flag: #fixme. " we assume that the user is typing in the first cell and may want to override an existing message "
	selector := (signature selector splitBy: ':') first.
	self updateSuggestions: ((self actualReceiver completionSuggestionsFor: selector) collect: [:sel | SBSuggestionItem selector: sel label: 'send']) showNear: signature