as yet unclassified
initialize

	super initialize.
	
	self
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		height: self fontToUse height;
		layoutPolicy: self