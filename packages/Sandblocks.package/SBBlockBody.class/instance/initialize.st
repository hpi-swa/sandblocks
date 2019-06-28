as yet unclassified
initialize

	super initialize.
	
	bindings := SBBlock new
		changeTableLayout;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		extent: 0 @ 0;
		yourself.
	temporaries := SBTemporaries new.
	
	self
		changeTableLayout;
		color: Color random;
		cellPositioning: #topLeft;
		listDirection: #topToBottom;
		vResizing: #shrinkWrap; hResizing: #shrinkWrap;
		addMorphBack: bindings;
		addMorphBack: temporaries