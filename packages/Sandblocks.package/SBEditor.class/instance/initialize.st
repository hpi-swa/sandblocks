initialize-release
initialize

	super initialize.
	
	unsavedChanges := false.
	singleSelectionShortcuts := OrderedCollection new.
	multiSelectionShortcuts := OrderedCollection new.
	commandShortcuts := OrderedCollection new.
	globalShortcuts := OrderedCollection new.
	inputShortcuts := OrderedCollection new.
	multiSelection := OrderedCollection new.
	colorPolicy := SBDefaultColorPolicy new.
	
	self
		addKeyboardCaptureFilter: self;
		addDefaultShortcuts;
		
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #topToBottom;
		
		addMorphBack: (scroll := SBScrollPane new
			showHScrollBarOnlyWhenNeeded;
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			yourself);
		
		addMorphBack: (Morph new
			changeTableLayout;
			vResizing: #rigid;
			cellInset: 8 * self scalingFactor;
			extent: 0 @ self copyBufferPreviewSize y;
			hResizing: #spaceFill;
			listDirection: #leftToRight;
			color: Color transparent;
			addMorphBack: (modeLabel := StringMorph new emphasis: TextEmphasis bold emphasisCode);
			addMorphBack: (selectionLabel := StringMorph new contents: '');
			addMorphBack: (Morph new extent: 0 @ 0; hResizing: #spaceFill; color: Color transparent);
			addMorphBack: (copyBufferPreview := ImageMorph new image: (Form extent: self copyBufferPreviewSize));
			yourself).
	
	scroll scroller addMorphBack: (methodContainer := SBMethodContainer new editor: self)