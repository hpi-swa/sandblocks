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
	bottomPanel color: (mode caseOf: {
		[#input] -> [Color red alpha: 0.2].
		[#selection] -> [Color blue alpha: 0.2].
		[#command] -> [Color white]
	}).
	self updateSelectionLabel