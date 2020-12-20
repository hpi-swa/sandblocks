as yet unclassified
keyStroke: anEvent

	(anEvent keyCharacter = Character space or: [
		(self selector notEmpty and: [self isBinary not]) and: [anEvent keyCharacter isSpecial]]) ifTrue: [
			self sandblockEditor endInput.
			^ self wrapInMessageSend: (anEvent keyCharacter isSpecial ifTrue: [anEvent keyCharacter asString] ifFalse: [''])].
	
	(anEvent keyCharacter = Character backspace and: [self selector isEmpty]) ifTrue: [ | receiver |
		receiver := self receiver.
		^ self sandblockEditor
			endInput;
			do: ((SBReplaceCommand newFor: self containingArtefact)
				target: self;
				replacer: receiver);
			startInput: receiver at: 9e8 replacingContents: false].
	
	signature keyStroke: anEvent.
	self updateSuggestions