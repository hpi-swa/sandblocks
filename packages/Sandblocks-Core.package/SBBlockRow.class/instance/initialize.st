as yet unclassified
initialize

	super initialize.
	
	self
		color: Color transparent;
		cellGap: 2 * self scalingFactor;
		extent: 0 @ 0;
		layoutPolicy: SBAlgebraLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		yourself