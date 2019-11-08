as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		cellGap: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (display := ECSWatchView new dark: true)