as yet unclassified
handleMouseEnter: anEvent
	
	self activeHand newKeyboardFocus: editor.
	anEvent wasHandled: true