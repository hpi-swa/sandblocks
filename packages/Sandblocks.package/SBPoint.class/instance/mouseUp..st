as yet unclassified
mouseUp: anEvent

	super mouseUp: anEvent.
	isDown := false.
	oldCursor ifNotNil: #show.
	
	self sandblockEditor do: (scrubbingCommand value: self contents).
	scrubbingCommand := nil