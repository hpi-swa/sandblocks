as yet unclassified
initialize

	super initialize.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		cellInset: 8 * self scalingFactor;
		addMorphBack: (inputs := SBColumn new);
		addMorphBack: (outputs := SBColum new);
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 8 * self scalingFactor