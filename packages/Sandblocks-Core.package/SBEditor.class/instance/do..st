actions
do: aCommand

	" the command may interrupt/replace an input "
	currentInputCommand notNil ifTrue: [self endInput].
	
	(undoStack notEmpty and: [undoStack last shouldMergeWithNext])
		ifTrue: [undoStack addLast: (SBCombinedCommand newWith: {undoStack removeLast. aCommand})]
		ifFalse: [undoStack addLast: aCommand].
	
	redoStack removeAll.
	
	aCommand previousSelection: self selection.
	self select: aCommand do.
	aCommand postDo.
	
	self markChangesAfterCommand: aCommand.
	self updateVerticalSelectionPosition 