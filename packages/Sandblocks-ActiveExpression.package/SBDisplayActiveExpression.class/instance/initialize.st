as yet unclassified
initialize

	super initialize.
	
	marbles := SBAEMarbles new.
	invocations := SBAEInvocations new.
	
	self
		color: Color transparent;
		changeTableLayout;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		listDirection: #topToBottom;
		cellPositioning: #topLeft;
		cellGap: 4 * self scalingFactor;
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (SBIcon iconCrosshairs);
			addMorphBack: (SBIcon iconShare on: #click send: #showSubscribers to: self);
			addMorphBack: (SBIcon iconSearch_plus on: #click send: #toggleMarbles to: self));
		addMorphBack: invocations