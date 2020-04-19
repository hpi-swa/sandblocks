as yet unclassified
keyStroke: anEvent

	anEvent keyCharacter = Character cr
		ifTrue: [
			currentFocus ifNotNil: #select.
			self sandblockEditor endInput.
			currentFocusIndicator detach]
		ifFalse: [super keyStroke: anEvent]