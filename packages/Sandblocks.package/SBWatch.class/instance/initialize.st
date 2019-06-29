as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		cellInset: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (display := SBStringMorph new color: Color white; contents: '...')