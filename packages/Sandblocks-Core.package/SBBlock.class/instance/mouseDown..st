event handling
mouseDown: anEvent

	self eventHandler
		ifNotNil: [self eventHandler mouseDown: anEvent fromMorph: self].
	
	anEvent hand waitForClicksOrDrag: self event: anEvent