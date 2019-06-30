actions
redo

	| command |
	redoStack ifNotEmpty: [
		command := redoStack removeLast.
		undoStack addLast: command.
		self select: command do.
		self unsavedChanges: true]