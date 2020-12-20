as yet unclassified
initialize

	super initialize.
	
	flowIn := SBNodeSocket new
		type: #flowIn;
		when: #connected send: #hasFlowOut: to: self with: true.
	flowOut := SBNodeSocket new type: #flowOut.
	isFlowSource := false.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		wrapCentering: #center;
		cellGap: 8 * self scalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		
		addMorphBack: (SBRow new
			changeTableLayout;
			addMorphBack: (inputs := SBColumn new);
			addMorphBack: (outputs := SBColumn new))