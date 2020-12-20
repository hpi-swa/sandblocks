as yet unclassified
initialize

	super initialize.
	self
		changeTableLayout;
		hResizing: #rigid;
		vResizing: #rigid;
		extent: 50 @ 50;
		layoutInset: 8