actions
undo

	| command |
	undoStack ifNotEmpty: [
		command := undoStack removeLast.
		redoStack addLast: command.
		command undo.
		undoStack ifEmpty: [self unsavedChanges: false]]