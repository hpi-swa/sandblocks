as yet unclassified
initialize

	super initialize.
	self
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6 withScalingFactor;
		cellGap: 8 withScalingFactor.
	
	frames := SBColumn new