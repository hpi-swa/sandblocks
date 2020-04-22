as yet unclassified
initialize

	super initialize.
	
	self
		addMorphBack: SBIcon iconCheck_square_o;
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		value: false