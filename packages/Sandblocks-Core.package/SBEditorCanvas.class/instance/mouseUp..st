as yet unclassified
mouseUp: anEvent 
	(dragLeftOverVelocity closeTo: 0 @ 0)
		ifFalse: [self startSteppingSelector: #finishDragVelocity].
	dragging := false