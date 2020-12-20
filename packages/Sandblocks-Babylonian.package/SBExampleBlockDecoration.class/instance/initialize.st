as yet unclassified
initialize

	super initialize.
	
	examples := Dictionary new.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		listDirection: #topToBottom