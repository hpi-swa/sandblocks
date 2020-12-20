as yet unclassified
testBinaryMessageEdit

	| message editor |
	message := '5 + 2' parseAsSandblock.
	editor := self editorFor: message.
	editor startInput: message at: 0 replacingContents: false.
	message messageParts first keyStroke: (self keyboardEvent: $-).
	self assert: message selector = '-+'.
	message messageParts first keyStroke: (self keyboardEvent: Character backspace).
	self assert: message selector = '+'.
	message messageParts first keyStroke: (self keyboardEvent: $4).
	self assert: message arguments first contents = '42'.
	self assert: message arguments first isSelected