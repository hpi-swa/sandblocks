as yet unclassified
initialize

	super initialize.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		layoutInset: 10 * self scalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellGap: 4 * self scalingFactor