initialize-release
initialize

	super initialize.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #topToBottom.
	
	undoStack := OrderedCollection new.
	redoStack  := OrderedCollection new.
	
	self addMorph: (Morph new
		changeTableLayout;
		vResizing: #rigid;
		extent: 0 @ self copyBufferPreviewSize y;
		hResizing: #spaceFill;
		listDirection: #leftToRight;
		color: Color transparent;
		addMorphBack: (modeLabel := StringMorph new contents: 'NORMAL');
		addMorphBack: (Morph new extent: 0 @ 0; hResizing: #spaceFill; color: Color transparent);
		addMorphBack: (copyBufferPreview := ImageMorph new image: (Form extent: self copyBufferPreviewSize))).
	self addKeyboardCaptureFilter: self