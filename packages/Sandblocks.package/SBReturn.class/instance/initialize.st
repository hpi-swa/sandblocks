as yet unclassified
initialize

	super initialize.
	
	pc := 0.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap