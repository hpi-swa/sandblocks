actions
redo
	<action>
	<inputAction>

	| command |
	redoStack ifNotEmpty: [
		command := redoStack removeLast.
		undoStack addLast: command.
		self select: command do.
		self markChangesAfterCommand: command]