initialization
initialize

	super initialize.
	
	data := ECSCyclicList new.
	label := ''.
	labelColor := Color black.
	
	self
		hResizing: #spaceFill;
		vResizing: #rigid;
		height: TextStyle defaultFont height * 2