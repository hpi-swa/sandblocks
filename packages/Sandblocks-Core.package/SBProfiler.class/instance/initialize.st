as yet unclassified
initialize

	super initialize.
	
	self
		hResizing: #rigid;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 4 withScalingFactor;
		attachDecorator: SBMoveDecorator new;
		extent: 300 @ self fontToUse height