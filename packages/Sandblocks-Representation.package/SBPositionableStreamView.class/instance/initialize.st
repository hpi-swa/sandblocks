as yet unclassified
initialize

	super initialize.
	
	self
		attachDecorator: SBMoveDecorator new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		addMorphBack: SBRow new;
		addMorphBack: (SBNumberWithPrefix new prefix: 'Position: ');
		addMorphBack: (SBNumberWithPrefix new prefix: 'Limit: ')