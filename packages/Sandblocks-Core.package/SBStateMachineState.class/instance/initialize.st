as yet unclassified
initialize

	super initialize.
	self addMorphBack: (label := SBTextBubble new).
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 6 withScalingFactor;
		attachDecorator: SBMoveDecorator new;
		attachDecorator: SBResizableDecorator new