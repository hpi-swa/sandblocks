as yet unclassified
initialize

	super initialize.
	
	self
		addMorphBack: (text := SBOwnTextMorph new emphasis: TextEmphasis bold);
		layoutPolicy: SBAlgebraLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap