event handling
mouseWheel: anEvent

	(anEvent commandKeyPressed and: [dragStartPosition notNil])
		ifTrue: [self zoomViewport: anEvent wheelDelta y from: dragStartPosition]
		ifFalse: [self viewportPosition: targetPosition + anEvent wheelDelta negated]