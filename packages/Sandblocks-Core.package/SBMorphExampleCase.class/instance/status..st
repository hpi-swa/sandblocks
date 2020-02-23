as yet unclassified
status: aSymbol

	status := aSymbol.
	self updateLabel.
	aSymbol ~= #manualRestart ifTrue: [self run]