as yet unclassified
initialize

	super initialize.
	
	self
		changeProportionalLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #topToBottom.
	
	undoStack := OrderedCollection new.
	redoStack  := OrderedCollection new.
	
	self
		addMorph: (copyBufferPreview := ImageMorph new image: (Form extent: self copyBufferPreviewSize))
		fullFrame: (LayoutFrame fractions: (1 @ 0 extent: 0 @ 0) offsets: (self copyBufferPreviewSize x negated @ 0 extent: self copyBufferPreviewSize)).
	
	self addKeyboardCaptureFilter: self