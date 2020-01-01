as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: (12 @ 6) withScalingFactor;
		addMorphBack: (activeIcon := SBIcon iconBug);
		on: #doubleClick send: #toggleActive to: self;
		active: true