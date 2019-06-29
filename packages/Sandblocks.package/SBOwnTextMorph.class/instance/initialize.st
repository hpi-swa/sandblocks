as yet unclassified
initialize

	super initialize.
	
	self vResizing: #shrinkWrap; hResizing: #shrinkWrap.
	self extent: 0 @ 0.
	
	cursor := 0.
	contents := ''.
	emphasis := TextEmphasis normal