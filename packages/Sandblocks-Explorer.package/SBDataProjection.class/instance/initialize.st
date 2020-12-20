as yet unclassified
initialize

	super initialize.
	self
		attachDecorator: SBMoveDecorator new;
		attachDecorator: SBResizableDecorator new