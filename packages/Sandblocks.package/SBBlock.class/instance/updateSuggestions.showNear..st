suggestions
updateSuggestions: aCollection showNear: aMorph

	(aCollection isEmpty or: [self hasInput not]) ifTrue: [^ self removeSuggestionMenu].
	
	self suggestionsMenu
		editor: self sandblockEditor;
		suggestions: (aCollection first: (20 min: aCollection size));
		topLeft: aMorph positionInWorld + (0 @ aMorph height);
		openInWorld;
		resize