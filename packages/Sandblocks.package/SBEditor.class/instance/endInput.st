input
endInput

	currentInput ifNil: [^ self].
	
	modeLabel contents: 'NORMAL'.
	currentInput stopEditing: currentInputCommand.
	
	currentInputCommand hasChange
		ifTrue: [self do: currentInputCommand]
		ifFalse: [undoStack ifNotEmpty: [undoStack last shouldMergeWithNext: false]].
	
	currentInput := nil.
	currentInputCommand := nil.