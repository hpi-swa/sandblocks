as yet unclassified
initialize

	super initialize.
	
	flowIn := SBNewNodeSocket new type: #flowIn.
	flowOut := SBNewNodeSocket new type: #flowOut.
	
	self
		listDirection: #topToBottom;
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		color: Color white;
		addMorphBack: (inOutMorphs := SBRow new
			changeTableLayout;
			cellGap: 12;
			addMorphBack: (inputMorphs := SBColum new changeTableLayout);
			addMorphBack: (outputMorphs := SBColum new changeTableLayout));
		update