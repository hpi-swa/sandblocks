as yet unclassified
initialize

	super initialize.
	
	type := #dynamic.
	
	self
		cellGap: 4 withScalingFactor;
		extent: self minExtent