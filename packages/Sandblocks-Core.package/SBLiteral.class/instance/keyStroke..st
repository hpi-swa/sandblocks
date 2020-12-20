as yet unclassified
keyStroke: anEvent

	"(self isExpression and: [anEvent keyCharacter isSpecial or: [anEvent keyCharacter = Character space]]) ifTrue: [
		(self parentSandblock isMessageSend and: [
			self parentSandblock selector = SBMessageSend placeholderSelector]) ifTrue: [
			^ self sandblockEditor
				endInput;
				startInput: self parentSandblock at: 1 replacingContents: true].
		
		self sandblockEditor endInput.
		^ self wrapInMessageSend: (anEvent keyCharacter isSpecial ifTrue: [anEvent keyCharacter asString] ifFalse: [''])].
	"
	(anEvent keyCharacter = Character backspace and: [self contents isEmpty]) ifTrue: [^ self replaceWithUnknown].
	
	self acceptInputEvent: anEvent