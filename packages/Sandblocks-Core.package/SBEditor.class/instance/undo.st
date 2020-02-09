actions
undo

	| command |
	undoStack ifNotEmpty: [
		command := undoStack removeLast.
		redoStack addLast: command.
		command undo.
		self select: command previousSelection.
		self markChangesAfterCommand: command]