as yet unclassified
initialize

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 8 * self scalingFactor;
		addMorphBack: (view := PasteUpMorph new);
		addMorphBack: (cases := SBColumn new layoutInset: 0)