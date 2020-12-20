as yet unclassified
initialize

	super initialize.
	
	self
		color: Color transparent;
		cellGap: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		changeListDirection: #leftToRight;
		addMorphBack: (label := SBStringMorph new);
		addMorphBack: (statusLabel := SBStringMorph new contents: '');
		addMorphBack: (display := SBNewWatchView new)