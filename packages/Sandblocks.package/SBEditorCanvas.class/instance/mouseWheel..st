as yet unclassified
mouseWheel: anEvent

	anEvent commandKeyPressed
		ifTrue: [self zoomViewport: anEvent wheelDelta y from: dragStartPosition]
		ifFalse: [self viewportPosition: targetPosition + anEvent wheelDelta negated]