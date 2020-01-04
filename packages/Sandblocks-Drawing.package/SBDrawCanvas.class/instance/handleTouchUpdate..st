as yet unclassified
handleTouchUpdate: anEvent 
	self
		fillFrom: (lastTouchPositions
				at: anEvent sequence
				ifAbsent: [^ self])
		to: anEvent position.
	lastTouchPositions at: anEvent sequence put: anEvent position