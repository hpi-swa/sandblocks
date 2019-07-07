as yet unclassified
initialize

	super initialize.
	
	active := false.
	
	self
		layoutInset: 10 @ 4 * self scalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #spaceFill;
		extent: 0 @ 0