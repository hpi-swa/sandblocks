as yet unclassified
stopEditing: aCommand

	aCommand
		newText: self contents;
		newMorph: self.
	
	text stopEditing.
	
	self removeSuggestionMenu