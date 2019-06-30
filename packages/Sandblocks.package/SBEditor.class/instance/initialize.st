initialize-release
initialize

	super initialize.
	
	self
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #topToBottom.
	
	self addMorph: (Morph new
		changeTableLayout;
		vResizing: #rigid;
		cellInset: 8 * self scalingFactor;
		extent: 0 @ self copyBufferPreviewSize y;
		hResizing: #spaceFill;
		listDirection: #leftToRight;
		color: Color transparent;
		addMorphBack: (modeLabel := StringMorph new emphasis: TextEmphasis bold emphasisCode; contents: 'NORMAL');
		addMorphBack: (selectionLabel := StringMorph new contents: '');
		addMorphBack: (Morph new extent: 0 @ 0; hResizing: #spaceFill; color: Color transparent);
		addMorphBack: (copyBufferPreview := ImageMorph new image: (Form extent: self copyBufferPreviewSize))).
	self addKeyboardCaptureFilter: self