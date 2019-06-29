as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #topToBottom.
	
	undoStack := OrderedCollection new.
	redoStack  := OrderedCollection new.
	
	self addKeyboardCaptureFilter: self