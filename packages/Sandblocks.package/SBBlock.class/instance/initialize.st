as yet unclassified
initialize

	super initialize.
	
	self
		color: Color transparent;
		cellPositioning: #topLeft;
		layoutInset: 2 * self scalingFactor;
		cellGap: 2 * self scalingFactor;
		extent: 0 @ 0