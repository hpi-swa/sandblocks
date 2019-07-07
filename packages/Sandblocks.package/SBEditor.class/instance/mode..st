events
mode: aSymbol

	aSymbol = #input
		ifTrue: [self assert: currentInput notNil]
		ifFalse: [self assert: currentInput isNil].
	
	aSymbol = #selection
		ifFalse: [self assert: multiSelection isEmpty].
	
	mode := aSymbol.
	modeLabel contents: (mode caseOf: {
		[#input] -> ['INPUT'].
		[#selection] -> ['SELECTION'].
		[#command] -> ['COMMAND']
	}).
	self updateSelectionLabel