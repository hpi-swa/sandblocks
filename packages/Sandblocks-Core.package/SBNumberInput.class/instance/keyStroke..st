event handling
keyStroke: anEvent

	super keyStroke: anEvent.
	
	self valueWithConstraints: ([self contents asNumber] on: NumberParserError do: [self value]).
	self sendChange