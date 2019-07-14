as yet unclassified
initialize

	super initialize.
	
	type := #dynamic.
	
	self
		layoutPolicy: SBArrayLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #leftToRight;
		extent: self minExtent