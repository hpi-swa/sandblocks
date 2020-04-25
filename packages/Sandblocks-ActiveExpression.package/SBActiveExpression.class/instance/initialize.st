initialization
initialize

	super initialize.
	
	self
		layoutInset: 2 withScalingFactor;
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		cellPositioning: #center;
		addMorphBack: (SBIcon iconExternal_link color: Color black)