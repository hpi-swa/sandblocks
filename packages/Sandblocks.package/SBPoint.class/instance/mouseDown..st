as yet unclassified
mouseDown: anEvent

	super mouseDown: anEvent.
	
	self valid ifFalse: [^ self].
	
	anEvent hand newMouseFocus: self.
	isDown := true.
	lastMousePosition := anEvent position.
	scrubbingCommand := SBMutatePropertyCommand new
		oldValue: self contents;
		selector: #contents;
		target: self.
	
	oldCursor := Cursor currentCursor.
	Cursor resizeLeft show