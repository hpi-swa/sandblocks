as yet unclassified
initialize

	super initialize.
	
	self
		cellGap: 4 withScalingFactor;
		layoutInset: 2 withScalingFactor;
		addMorphBack: (display := SBNewWatchView new)