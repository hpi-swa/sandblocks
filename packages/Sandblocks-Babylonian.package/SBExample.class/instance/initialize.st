as yet unclassified
initialize

	super initialize.
	
	active := false.
	processRunning := false.
	
	self
		layoutInset: 8 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellGap: 4 * self scalingFactor