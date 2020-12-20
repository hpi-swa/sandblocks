as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 2 withScalingFactor;
		addMorphBack: (indicator := Morph new
			extent: 16 asPoint * self scalingFactor;
			color: Color red)