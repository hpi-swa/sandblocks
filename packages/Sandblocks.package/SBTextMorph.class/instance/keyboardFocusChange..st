as yet unclassified
keyboardFocusChange: anEvent

	" make sure we redraw focus outlines "
	self changed.
	^ super keyboardFocusChange: anEvent