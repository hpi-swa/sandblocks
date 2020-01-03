as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		layoutInset: 4 withScalingFactor;
		cellGap: 4 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (SBRow new
			cellGap: 4 withScalingFactor;
			addMorphBack: (comment := SBTextBubble new layoutInset: (6 @ 2) withScalingFactor; colored: false);
			addMorphBack: (active := SBBoolean new contents: 'false'; when: #toggled send: #update to: self))