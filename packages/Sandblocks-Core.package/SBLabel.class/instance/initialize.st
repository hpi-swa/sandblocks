as yet unclassified
initialize

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 0 withScalingFactor;
		addMorphBack: (text := SBMultilineOwnTextMorph new emphasis: TextEmphasis italic);
		headingLevel: 0