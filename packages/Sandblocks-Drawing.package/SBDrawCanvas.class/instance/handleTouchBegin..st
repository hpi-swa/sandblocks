as yet unclassified
handleTouchBegin: anEvent

	lastTouchPositions ifEmpty: [self beginDraw].
	lastTouchPositions at: anEvent sequence put: anEvent position