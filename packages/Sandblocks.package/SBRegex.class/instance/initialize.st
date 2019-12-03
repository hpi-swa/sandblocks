as yet unclassified
initialize

	super initialize.
	
	self
		layoutInset: 4 * self scalingFactor;
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		addMorphBack: (text := SBString new castToUnknownWhenEmpty: false);
		addMorphBack: ((exampleLabel  := SBStringMorph new) on: #click send: #toggleExamples to: self);
		addMorphBack: (examples := SBColum new);
		updateLabel