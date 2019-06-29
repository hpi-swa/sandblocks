as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #leftToRight;
		layoutInset: 2;
		cellInset: 2;
		extent: 0 @ 0