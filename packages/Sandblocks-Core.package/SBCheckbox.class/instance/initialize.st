as yet unclassified
initialize

	super initialize.
	
	nonEdit := false.
	value := false.
	
	self
		addMorphBack: SBIcon iconCheck_square_o;
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap