as yet unclassified
initialize

	super initialize.
	
	isDown := false.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap