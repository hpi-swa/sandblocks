actions
redo

	| command |
	redoStack ifNotEmpty: [
		command := redoStack removeLast.
		undoStack addLast: command.
		command do.
		self unsavedChanges: true]