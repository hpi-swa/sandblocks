as yet unclassified
initialize

	super initialize.
	
	type := #dynamic.
	addType := SBUnknown.
	
	self
		layoutPolicy: SBArrayLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		cellGap: 4 withScalingFactor;
		listDirection: #leftToRight;
		extent: self minExtent