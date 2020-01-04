as yet unclassified
initialize

	super initialize.
	
	velocity := 0 @ 0.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap