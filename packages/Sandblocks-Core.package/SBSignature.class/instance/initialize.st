as yet unclassified
initialize

	super initialize.
	
	self
		layoutPolicy: SBKeywordMessageLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		cellGap: 2 * self scalingFactor;
		color: Color transparent