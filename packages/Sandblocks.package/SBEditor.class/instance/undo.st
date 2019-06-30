actions
undo

	| command |
	undoStack ifNotEmpty: [
		command := undoStack removeLast.
		redoStack addLast: command.
		self select: command undo.
		undoStack ifEmpty: [self unsavedChanges: false]]