as yet unclassified
initialize

	super initialize.
	
	self
		addMorphBack: (text := SBOwnTextMorph new);
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap