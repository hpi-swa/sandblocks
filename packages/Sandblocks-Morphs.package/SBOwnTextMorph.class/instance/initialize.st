as yet unclassified
initialize
	
	super initialize.
	self
		vResizing: #spaceFill;
		hResizing: #spaceFill.
	self extent: 0 @ 0.
	cursor := 0.
	suffix := ''.
	contents := ''.
	colorAlpha := 1.
	emphasis := TextEmphasis normal