as yet unclassified
initialize

	super initialize.
	
	self wrapFlag: false.
	self vResizing: #shrinkWrap; hResizing: #shrinkWrap.
	self extent: 0 @ 0