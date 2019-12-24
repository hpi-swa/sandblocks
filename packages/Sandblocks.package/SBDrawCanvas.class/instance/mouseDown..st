as yet unclassified
mouseDown: anEvent 
	drawing := true.
	lastMousePosition := anEvent position.
	self mouseMove: anEvent