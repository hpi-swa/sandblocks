as yet unclassified
initialize

	super initialize.
	
	self
		addMorphBack: (text := SBTextMorph new);
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap