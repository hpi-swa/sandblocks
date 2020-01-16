as yet unclassified
initialize

	super initialize.
	
	decorators := OrderedCollection new.
	
	self
		color: Color transparent;
		cellPositioning: #topLeft;
		layoutInset: (2 @ 2) withScalingFactor;
		cellGap: 1 * self scalingFactor;
		extent: 0 @ 0