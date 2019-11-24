colors
initialize

	super initialize.
	
	size := #regular.
	
	self color: Color black.
	self vResizing: #shrinkWrap; hResizing: #shrinkWrap.
	self extent: 0 @ 0