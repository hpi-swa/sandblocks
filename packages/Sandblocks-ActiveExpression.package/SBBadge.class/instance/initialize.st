initialization
initialize

	super initialize.
	
	self
		layoutInset: 4 * self scalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap