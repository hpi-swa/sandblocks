as yet unclassified
initialize

	super initialize.
	
	self
		color: Color transparent;
		changeTableLayout;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		listDirection: #topToBottom;
		cellPositioning: #topLeft;
		cellGap: 4 * self scalingFactor