initialization
initialize

	super initialize.
	
	dragging := false.
	targetPosition := 0 @ 0.
	dragLeftOverVelocity := 0 @ 0.
	color := nil.
	self smoothing: 2