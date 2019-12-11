as yet unclassified
finishDragVelocity
	self moveViewport: dragLeftOverVelocity.
	dragLeftOverVelocity := dragLeftOverVelocity * 0.85.
	(dragLeftOverVelocity closeTo: 0 @ 0)
		ifTrue: [self stopSteppingSelector: #finishDragVelocity]