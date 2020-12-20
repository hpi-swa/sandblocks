as yet unclassified
initialize

	super initialize.
	
	comment := SBTextBubble new layoutInset: (6 @ 2) withScalingFactor; colored: false.
	
	self
		layoutInset: 2 withScalingFactor;
		cellGap: 4 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap