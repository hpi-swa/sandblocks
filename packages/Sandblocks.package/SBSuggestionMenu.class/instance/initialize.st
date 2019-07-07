as yet unclassified
initialize

	super initialize.
	
	activeIndex := 1.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellInset: 0;
		layoutInset: 0;
		color: Color white