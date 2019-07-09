as yet unclassified
mouseDown: anEvent

	super mouseDown: anEvent.
	
	self valid ifFalse: [^ self].
	
	anEvent hand newMouseFocus: self.
	isDown := true.
	lastMousePosition := anEvent position.
	
	oldCursor := Cursor currentCursor.
	Cursor resizeLeft show