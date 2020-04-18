as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 4 withScalingFactor;
		attachDecorator: (SBMoveDecorator new preventOcclusion: true)