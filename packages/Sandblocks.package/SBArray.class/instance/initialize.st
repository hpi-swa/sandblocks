as yet unclassified
initialize

	super initialize.
	
	type := #dynamic.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #leftToRight;
		extent: self minExtent