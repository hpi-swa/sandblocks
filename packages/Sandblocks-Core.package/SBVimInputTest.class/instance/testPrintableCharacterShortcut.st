as yet unclassified
testPrintableCharacterShortcut

	| message editor |
	message := '5 + 2' parseAsSandblock.
	editor := self editorFor: message.
	editor startInput: message at: 2 replacingContents: false.
	editor filterEvent: (self keyboardEvent: $+) for: nil.
	
	self assert: message selector = '++'