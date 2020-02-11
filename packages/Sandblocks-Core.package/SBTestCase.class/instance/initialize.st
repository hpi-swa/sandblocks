as yet unclassified
initialize

	super initialize.
	
	self
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 4 withScalingFactor;
		changeTableLayout;
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (selectorInput := SBTextBubble new);
			addMorphBack: (SBIcon iconPlay on: #click send: #runTest to: self);
			yourself)