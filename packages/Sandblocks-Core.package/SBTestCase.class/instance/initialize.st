as yet unclassified
initialize

	super initialize.
	
	self
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 8 withScalingFactor;
		cellGap: 8 withScalingFactor;
		changeTableLayout;
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (selectorInput := SBTextBubble new
				colored: false;
				layoutInset: 5 withScalingFactor;
				yourself);
			addMorphBack: (SBIcon iconPlay on: #click send: #runTest to: self);
			yourself)