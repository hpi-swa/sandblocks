as yet unclassified
do: aCommand

	undoStack addLast: aCommand.
	redoStack removeAll.
	aCommand do