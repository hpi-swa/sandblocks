as yet unclassified
initialize

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6 withScalingFactor;
		addMorphBack: (text := SBOwnTextMorph new emphasis: TextEmphasis italic);
		headingLevel: 0