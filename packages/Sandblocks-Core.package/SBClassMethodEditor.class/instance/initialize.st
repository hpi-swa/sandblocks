as yet unclassified
initialize

	super initialize.
	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		cellGap: 4;
		attachDecorator: SBMoveDecorator new