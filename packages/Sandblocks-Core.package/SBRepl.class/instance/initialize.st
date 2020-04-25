as yet unclassified
initialize

	super initialize.
	
	typeCache := Dictionary new.
	
	self
		layoutInset: 6 withScalingFactor;
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (SBTextBubble new layoutInset: 4 withScalingFactor; contents: 'REPL');
			addMorphBack: (bindings := SBRow new cellGap: 4 withScalingFactor));
		addMorphBack: SBBlockBody empty;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		changeTableLayout;
		attachDecorator: SBMoveDecorator new