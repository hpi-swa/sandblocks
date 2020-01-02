as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellGap: 6 withScalingFactor;
		layoutInset: 6 withScalingFactor;
		cellPositioning: #center;
		addMorphBack: SBIcon iconExclamation;
		addMorphBack: (coloredIndicator := Morph new extent: 16 asPoint withScalingFactor);
		on: #doubleClick send: #changeColor to: self