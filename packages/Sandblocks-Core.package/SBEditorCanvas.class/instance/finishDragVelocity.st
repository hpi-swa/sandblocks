viewport
finishDragVelocity

	self moveViewport: dragLeftOverVelocity.
	dragLeftOverVelocity := dragLeftOverVelocity * 0.85.
	(dragLeftOverVelocity closeTo: 0 @ 0)
		ifTrue: [
			self viewportPosition: targetPosition rounded.
			self stopSteppingSelector: #finishDragVelocity]