as yet unclassified
initialize

	super initialize.
	
	self
		color: Color transparent;
		changeTableLayout;
		cellGap: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		changeListDirection: #leftToRight;
		addMorphBack: (label := StringMorph new color: Color white);
		addMorphBack: (display := SBWatchView new dark: true)