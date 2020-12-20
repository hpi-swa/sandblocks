as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		cellGap: 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap