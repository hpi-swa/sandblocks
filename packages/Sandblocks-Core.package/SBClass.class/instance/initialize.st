as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		cellGap: 4 withScalingFactor;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutInset: 8 withScalingFactor;
		addMorphBack: (className := SBTextBubble new emphasis: TextEmphasis bold);
		addMorphBack: (superClassName := SBClassNameInput new);
		addMorphBack: (SBRow new
			cellGap: 4 withScalingFactor;
			addMorphBack: (SBStringMorph new contents: 'Instance Variables:');
			addMorphBack: (instanceVariables := SBArray new))