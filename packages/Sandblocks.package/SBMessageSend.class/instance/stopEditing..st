as yet unclassified
stopEditing: aCommand

	signature stopEditing: aCommand.
	suggestionMenu ifNotNil: [
		suggestionMenu delete.
		suggestionMenu := nil]