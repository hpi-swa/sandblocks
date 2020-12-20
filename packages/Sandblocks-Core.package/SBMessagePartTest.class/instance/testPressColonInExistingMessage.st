as yet unclassified
testPressColonInExistingMessage

	| message argument part |
	message := '5 yourself: 2' parseAsSandblock.
	part := message messageParts first.
	argument := message arguments first.
	(self editorFor: message) startInput: message at: 3 replacingContents: false.
	part keyStroke: (self keyboardEvent: $:).
	self assert: message selector = 'yourself:'.
	self assert: message arguments first = argument