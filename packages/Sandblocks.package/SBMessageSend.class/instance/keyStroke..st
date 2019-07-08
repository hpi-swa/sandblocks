as yet unclassified
keyStroke: anEvent

	anEvent keyCharacter = Character space ifTrue: [
		^ self sandblockEditor
			endInput;
			wrapInMessageSend: ''].

	signature keyStroke: anEvent.
	self updateSuggestions