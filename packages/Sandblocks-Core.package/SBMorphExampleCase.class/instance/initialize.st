initialization
initialize

	super initialize.
	
	status := #manualRestart.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		layoutInset: 8 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellGap: 4 withScalingFactor