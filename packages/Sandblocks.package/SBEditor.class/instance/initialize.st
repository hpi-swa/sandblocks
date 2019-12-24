initialize-release
initialize

	super initialize.
	
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
		
		extent: 500 asPoint;
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #topToBottom;
		
		addMorphBack: (scroll := SBEditorCanvas new
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			yourself);
		
		addMorphBack: (bottomPanel := Morph new
			changeTableLayout;
			cellPositioning: #topLeft;
			vResizing: #rigid;
			cellGap: 8 * self scalingFactor;
			extent: 0 @ self copyBufferPreviewSize y;
			hResizing: #spaceFill;
			wrapCentering: #center;
			layoutInset: 4 withScalingFactor @ 0;
			listDirection: #leftToRight;
			color: Color transparent;
			addMorphBack: (modeLabel := StringMorph new emphasis: TextEmphasis bold emphasisCode);
			addMorphBack: (selectionLabel := StringMorph new contents: '');
			addMorphBack: (Morph new extent: 0 @ 0; hResizing: #spaceFill; color: Color transparent);
			addMorphBack: (copyBufferPreview := ImageMorph new image: (Form extent: 1 @ 1));
			yourself);
		
		resetState