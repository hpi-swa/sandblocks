as yet unclassified
mouseUp: anEvent

	super mouseUp: anEvent.
	isDown := false.
	oldCursor ifNotNil: #show