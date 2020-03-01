initialization
initialize

	super initialize.
	
	dragging := false.
	targetPosition := 0 @ 0.
	dragLeftOverVelocity := 0 @ 0.
	self smoothing: 2.
	
	self color: Color white