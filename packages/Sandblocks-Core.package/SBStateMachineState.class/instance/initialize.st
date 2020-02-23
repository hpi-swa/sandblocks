as yet unclassified
initialize

	super initialize.
	self addMorphBack: (label := SBTextBubble new).
	self
		 changeTableLayout;
		 vResizing: #shrinkWrap;
		 hResizing: #shrinkWrap;
		 layoutInset: 8 withScalingFactor;
		 attachDecorator: SBMoveDecorator new