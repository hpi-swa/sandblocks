event handling
mouseDown: anEvent 
	anEvent hand waitForClicksOrDrag: self event: anEvent.
	self stopSteppingSelector: #finishDragVelocity.
	
	anEvent yellowButtonPressed ifTrue: [
		lastDragPosition := anEvent position.
		dragging := true]