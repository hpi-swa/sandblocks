actions
do: aCommand

	self unsavedChanges: (self unsavedChanges or: [aCommand wasEdit]).
	
	(undoStack notEmpty and: [undoStack last shouldMergeWithNext])
		ifTrue: [undoStack addLast: (SBCombinedCommand new commands: {undoStack removeLast. aCommand})]
		ifFalse: [undoStack addLast: aCommand].
	
	redoStack removeAll.
	
	self select: aCommand do.
	aCommand postDo.
	
	self triggerEvent: #change