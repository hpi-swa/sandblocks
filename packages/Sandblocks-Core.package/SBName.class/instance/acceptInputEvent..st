as yet unclassified
acceptInputEvent: anEvent

	anEvent keyCharacter isSeparator ifFalse: [super acceptInputEvent: anEvent]