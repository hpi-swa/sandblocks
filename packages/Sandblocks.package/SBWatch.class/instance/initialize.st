as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		cellInset: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (display := ECSWatchView new dark: true)