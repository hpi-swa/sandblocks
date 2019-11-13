as yet unclassified
initialize

	super initialize.
	
	exampleValues := Dictionary new.
	
	self
		changeTableLayout;
		cellGap: 4;
		layoutInset: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap