as yet unclassified
mouseDown: anEvent

	drawing := true.
	lastMousePosition := anEvent position.
	self beginDraw.
	self mouseMove: anEvent