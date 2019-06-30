actions
do: aCommand

	self unsavedChanges: true.
	undoStack addLast: aCommand.
	redoStack removeAll.
	aCommand do