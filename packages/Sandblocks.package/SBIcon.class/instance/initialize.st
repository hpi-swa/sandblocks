colors
initialize

	super initialize.
	
	size := #regular.
	color := nil.
	
	self vResizing: #shrinkWrap; hResizing: #shrinkWrap.
	self extent: 0 @ 0