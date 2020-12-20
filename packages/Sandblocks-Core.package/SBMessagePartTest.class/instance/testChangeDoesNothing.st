as yet unclassified
testChangeDoesNothing

	| message |
	message := '5 yourself' parseAsSandblock.
	self editorFor: message.
	message messageParts first select.
	message messageParts first changeToUnknown.
	self assert: message messageParts first isMessagePart