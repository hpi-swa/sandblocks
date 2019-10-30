as yet unclassified
initialize

	super initialize.
	
	self
		layoutInset: 4 * self scalingFactor;
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		addMorphBack: (SBStringMorph new contents: 'AE: ')