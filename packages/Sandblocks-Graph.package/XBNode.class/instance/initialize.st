as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		addMorphBack: (flowOut := SBNodeSocket new type: #flowOut; visible: false);
		addMorphBack: (flowIn := SBNodeSocket new type: #flowIn; visible: false);
		addMorphBack: (SBColumn new
			changeTableLayout;
			addMorphBack: (inputs := SBColumn new changeTableLayout);
			addMorphBack: (outputs := SBColumn new changeTableLayout))