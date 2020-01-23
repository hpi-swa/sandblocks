as yet unclassified
initialize

	super initialize.
	
	self
		color: Color transparent;
		layoutPolicy: SBVerticalLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		extent: 0 @ 0