as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		cellGap: 4 withScalingFactor;
		layoutInset: 2 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (display := SBWatchView new dark: true)