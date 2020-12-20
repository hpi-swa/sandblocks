as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		cellGap: 4 * self scalingFactor;
		cellPositioning: #center;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (image := ImageMorph new);
		addMorphBack: (infoLabel := SBStringMorph new)