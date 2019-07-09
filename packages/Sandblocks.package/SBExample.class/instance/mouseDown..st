as yet unclassified
mouseDown: anEvent

	anEvent yellowButtonPressed ifTrue: [lastError ifNotNil: [ToolSet debugError: lastError]. ^ self].
	anEvent hand waitForClicksOrDrag: self event: anEvent