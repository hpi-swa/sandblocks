as yet unclassified
initialize

	super initialize.
	self
		attachDecorator: SBMoveDecorator new;
		extent: 100 asPoint;
		attachDecorator: SBResizableDecorator new;
		changeTableLayout;
		layoutInset: 6 withScalingFactor