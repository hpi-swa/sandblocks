as yet unclassified
initialize

	super initialize.
	
	self
		layoutInset: 4 * self scalingFactor;
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		cellPositioning: #center;
		addMorphBack: (text := SBTextBubble new when: #contentsChanged send: #checkExamples to: self);
		addMorphBack: ((exampleLabel  := SBStringMorph new) on: #click send: #toggleExamples to: self);
		addMorphBack: ((examples := SBColum new) when: #morphAdded send: #checkExamples to: self);
		updateLabel