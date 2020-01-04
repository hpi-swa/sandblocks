as yet unclassified
keyStroke: anEvent

	(anEvent keyCharacter = Character space or: [(self selector notEmpty and: [self isBinary not]) and: [anEvent keyCharacter isSpecial]]) ifTrue: [
		^ self sandblockEditor
			endInput;
			wrapInMessageSend: (anEvent keyCharacter isSpecial ifTrue: [anEvent keyCharacter asString] ifFalse: [''])].
	
	signature keyStroke: anEvent.
	self updateSuggestions