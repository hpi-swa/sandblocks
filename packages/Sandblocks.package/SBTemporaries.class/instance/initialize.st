as yet unclassified
initialize

	super initialize.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutInset: 2;
		color: Color transparent;
		cellInset: 2;
		extent: 0 @ 0