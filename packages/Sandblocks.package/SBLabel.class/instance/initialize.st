as yet unclassified
initialize

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 8 * self scalingFactor;
		addMorphBack: (text := SBOwnTextMorph new emphasis: TextEmphasis italic)