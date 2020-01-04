as yet unclassified
initialize

	super initialize.
	
	pc := 0.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #leftToRight