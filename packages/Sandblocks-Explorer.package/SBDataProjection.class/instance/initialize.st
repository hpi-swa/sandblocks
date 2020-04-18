as yet unclassified
initialize

	super initialize.
	self
		attachDecorator: (SBMoveDecorator new preventOcclusion: true);
		attachDecorator: SBResizableDecorator new