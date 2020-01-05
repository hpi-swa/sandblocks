as yet unclassified
initialize

	super initialize.
	
	colorMapping := Dictionary new.
	
	self
		color: Color transparent;
		changeTableLayout;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		listDirection: #leftToRight;
		cellPositioning: #topLeft;
		wrapDirection: #leftToRight;
		minimumWidth: 200;
		extent: 0 @ 0;
		cellGap: 2 * self scalingFactor