accessing
mode: aSymbol

	self clearMultiSelection.
		
	aSymbol = #input ifTrue: [self assert: currentInput notNil] ifFalse: [self assert: currentInput isNil].
	(aSymbol = #selection or: [aSymbol = #continuousSelection]) ifFalse: [self assert: multiSelection isEmpty].
	
	mode := aSymbol.
	modeLabel contents: (mode caseOf: {
		([#input] -> ['INPUT']).
		([#selection] -> ['SELECTION']).
		([#continuousSelection] -> ['CONT. SELECTION']).
		([#command] -> ['COMMAND'])
	}).
	bottomPanel color: (mode caseOf: {
		([#input] -> [Color red alpha: 0.2]).
		([#selection] -> [Color blue alpha: 0.2]).
		([#continuousSelection] -> [Color blue alpha: 0.2]).
		([#command] -> [Color white])
	}).
	self selection ifNotNil: [:s | s invalidRect: (s outerBounds expandBy: 4)].
	self updateSelectionLabel