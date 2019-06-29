as yet unclassified
redo

	| command |
	redoStack ifNotEmpty: [
		command := redoStack removeLast.
		undoStack addLast: command.
		command do]