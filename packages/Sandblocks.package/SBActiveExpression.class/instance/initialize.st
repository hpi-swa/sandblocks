as yet unclassified
initialize

	super initialize.
	
	self
		layoutInset: 4 * self scalingFactor;
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		cellPositioning: #center;
		addMorphBack: (SBIcon iconExternal_link color: Color black)