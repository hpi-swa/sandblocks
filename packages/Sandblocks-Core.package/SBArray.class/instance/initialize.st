as yet unclassified
initialize

	super initialize.
	
	type := #dynamic.
	addType := SBUnknown.
	
	self
		layoutPolicy: SBArrayLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #leftToRight;
		extent: self minExtent