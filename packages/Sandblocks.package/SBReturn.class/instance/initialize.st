as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		addMorphBack: (SBStringMorph new contents: '^ ')