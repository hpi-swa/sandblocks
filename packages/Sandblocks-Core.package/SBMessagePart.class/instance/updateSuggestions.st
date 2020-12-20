as yet unclassified
updateSuggestions

	| selector |
	selector := self selectorContentsBeforeMe, self contents.
	selector ifEmpty: [^ self].
	
	selector last = $: ifTrue: [selector := selector allButLast].
	
	self updateSuggestions: ((self messageSend actualReceiver completionSuggestionsFor: selector) collect: [:sel | SBSuggestionItem selector: sel label: 'send']) showNear: self