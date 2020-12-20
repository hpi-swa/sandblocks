as yet unclassified
initialize

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		listDirection: #leftToRight;
		cellGap: 8;
		addMorphBack: (SBStringMorph new contents: '0');
		addMorphBack: (SimpleSliderMorph new
			hResizing: #spaceFill;
			target: self;
			truncate: true;
			actionSelector: #selectIteration:;
			yourself)