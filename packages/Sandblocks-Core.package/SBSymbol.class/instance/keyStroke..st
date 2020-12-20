as yet unclassified
keyStroke: anEvent

	anEvent keyCharacter isSpecial
		ifTrue: [self acceptInputEvent: anEvent]
		ifFalse: [super keyStroke: anEvent].
	
	self updateSuggestions