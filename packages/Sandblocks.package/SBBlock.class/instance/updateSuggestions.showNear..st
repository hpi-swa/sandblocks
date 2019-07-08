suggestions
updateSuggestions: aCollection showNear: aMorph

	(aCollection isEmpty or: [self hasInput not]) ifTrue: [^ self removeSuggestionMenu].
	
	self suggestionsMenu
		editor: self sandblockEditor;
		topLeft: aMorph bottomLeft;
		suggestions: (aCollection first: (20 min: aCollection size));
		openInWorld;
		resize