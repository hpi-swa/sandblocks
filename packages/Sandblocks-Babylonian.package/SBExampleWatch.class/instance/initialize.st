as yet unclassified
initialize

	super initialize.
	
	exampleValues := Dictionary new.
	
	self
		cellGap: 4 withScalingFactor;
		layoutInset: 2 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap