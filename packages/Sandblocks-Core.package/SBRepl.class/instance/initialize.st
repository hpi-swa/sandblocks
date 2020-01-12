as yet unclassified
initialize

	super initialize.
	
	self
		layoutInset: 8 withScalingFactor;
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (SBTextBubble new layoutInset: 4 withScalingFactor; contents: 'REPL');
			addMorphBack: (bindings := SBRow new));
		addMorphBack: SBBlockBody empty;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		changeTableLayout;
		attachDecorator: SBMoveDecorator new