event handling
mouseDown: anEvent

	super mouseDown: anEvent.
	anEvent hand newMouseFocus: self.
	isDown := true.
	lastMousePosition := anEvent position.
	
	oldCursor := Cursor currentCursor.
	Cursor resizeLeft show