as yet unclassified
initialize

	super initialize.
	
	self
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (StringMorph new contents: 'REPL');
			addMorphBack: (bindings := SBRow new));
		addMorphBack: SBBlockBody empty;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		changeTableLayout