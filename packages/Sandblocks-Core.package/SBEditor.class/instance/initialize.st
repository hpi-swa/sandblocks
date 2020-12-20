initialize-release
initialize

	super initialize.
	
	singleSelectionShortcuts := OrderedCollection new.
	multiSelectionShortcuts := OrderedCollection new.
	commandShortcuts := OrderedCollection new.
	inputShortcuts := OrderedCollection new.
	multiSelection := OrderedCollection new.
	colorPolicy := self class defaultColorPolicy new.
	compileTime := #compileOnSave.
	verticalSelectionPosition := 0.
	globalShortcutListeners := OrderedCollection new.
	inputMapping := self class newInputMapping.
	inputMapping applyFor: self.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		
		extent: 500 asPoint;
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #topToBottom;
		
		addMorphBack: (errors := SBErrorPanel new
			disableLayout: true;
			topLeft: self topLeft;
			yourself);
			
		addMorphBack: self buildCommandBar;
		"addMorphBack: self buildDebugCommandBar;"
		
		addMorphBack: (scroll := SBEditorCanvas new
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			yourself);
		
		addMorphBack: (bottomPanel := self buildBottomPanel);
		
		registerGlobalShortcutListener: self;
		registerGlobalShortcutListener: errors;
		
		resetState