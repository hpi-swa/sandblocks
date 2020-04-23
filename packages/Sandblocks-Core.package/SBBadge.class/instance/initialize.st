initialization
initialize

	super initialize.
	
	self
		layoutInset: 4 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellPositioning: #center