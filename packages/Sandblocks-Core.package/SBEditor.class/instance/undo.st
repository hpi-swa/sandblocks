actions
undo

	| command |
	undoStack ifNotEmpty: [ | ret |
		command := undoStack removeLast.
		redoStack addLast: command.
		ret := command undo.
		self select: ((command previousSelection notNil and: [command previousSelection isInWorld]) ifTrue: [command previousSelection] ifFalse: [ret]).
		self markChangesAfterCommand: command]