as yet unclassified
initialize

	super initialize.
	
	self
		color: Color transparent;
		layoutPolicy: SBHorizontalLayout new;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 2 * self scalingFactor;
		cellInset: 2 * self scalingFactor;
		extent: 0 @ 0;
		yourself