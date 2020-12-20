as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		borderStyle: (BorderStyle width: 1 color: Color veryLightGray);
		listDirection: #leftToRight;
		cellGap: 8 withScalingFactor;
		layoutInset: (8 @ 4) withScalingFactor;
		color: Color white;
		cornerStyle: #rounded;
		on: #mouseEnter send: #mouseEntered to: self;
		on: #mouseLeave send: #mouseLeft to: self;
		on: #mouseDown send: #mousePressed to: self;
		on: #mouseLeaveDragging send: #mouseLeft to: self;
		on: #click send: #clicked to: self