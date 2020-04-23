as yet unclassified
initialize

	super initialize.
	self
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 8 withScalingFactor;
		cellGap: 8 withScalingFactor.
	
	frames := SBColumn new