as yet unclassified
initialize

	super initialize.
	
	decorators := OrderedCollection new.
	
	self
		color: Color transparent;
		cellPositioning: #topLeft;
		layoutInset: 0;
		cellGap: 1 withScalingFactor;
		extent: 0 @ 0