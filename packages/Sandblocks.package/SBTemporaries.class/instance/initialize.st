as yet unclassified
initialize

	super initialize.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutInset: (Rectangle left: 4 * self scalingFactor right: 4 * self scalingFactor top: 2 * self scalingFactor bottom: 2 * self scalingFactor);
		color: Color transparent;
		cellInset: 2 * self scalingFactor;
		extent: 0 @ 0