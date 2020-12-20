as yet unclassified
initialize

	super initialize.
	count := 0.
	self
		changeTableLayout;
		cellGap: 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #leftToRight;
		layoutInset: 8;
		cellPositioning: #center;
		addMorphBack: SBBadge new;
		addMorphBack: (SBNumberWithPrefix new
			value: 5;
			prefix: '#');
		attachDecorator: SBMoveDecorator new