as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		layoutInset: 4 withScalingFactor;
		cellGap: 4 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (comment := SBTextBubble new layoutInset: (6 @ 2) withScalingFactor; colored: false)