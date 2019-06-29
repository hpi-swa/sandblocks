as yet unclassified
initialize

	super initialize.
	
	self
		addMorphBack: (text := SBOwnTextMorph new);
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap