as yet unclassified
initialize

	super initialize.
	
	self
		extent: 0 @ 0;
		color: Color transparent;
		layoutPolicy: SBHorizontalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap