as yet unclassified
initialize

	super initialize.
	
	marked := false.
	decorators := OrderedCollection new.
	
	self
		color: Color transparent;
		cellPositioning: #topLeft;
		layoutInset: "2 * self scalingFactor" (2 @ 2);
		cellGap: 2 * self scalingFactor;
		extent: 0 @ 0