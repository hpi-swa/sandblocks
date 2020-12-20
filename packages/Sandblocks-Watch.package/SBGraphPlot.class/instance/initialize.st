initialization
initialize

	data := SBCyclicList new.
	super initialize.
	label := ''.
	labelColor := Color black.
	self
		hResizing: #spaceFill;
		vResizing: #rigid;
		height: TextStyle defaultFont height * 2