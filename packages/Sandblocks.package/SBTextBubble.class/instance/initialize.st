as yet unclassified
initialize

	super initialize.
	
	colored := true.
	
	self
		addMorphBack: (text := SBOwnTextMorph new);
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap