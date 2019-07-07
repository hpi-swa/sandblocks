as yet unclassified
updateSuggestions

	| suggestions |
	suggestionMenu ifNil: [
		suggestionMenu := SBSuggestionMenu new
			editor: self sandblockEditor;
			openInWorld;
			topLeft: signature bottomLeft].
	
	suggestions := self receiver completionSuggestionsFor: signature selector.
	suggestionMenu suggestions: (suggestions first: (20 min: suggestions size)).
	
	suggestionMenu resize