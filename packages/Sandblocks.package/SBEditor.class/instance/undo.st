as yet unclassified
undo

	| command |
	undoStack ifNotEmpty: [
		command := undoStack removeLast.
		redoStack addLast: command.
		command undo]