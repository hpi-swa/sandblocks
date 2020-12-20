as yet unclassified
testTypeBinary

	| receiver message editor |
	receiver := SBUnknown new.
	editor := self editorFor: receiver.
	message := receiver wrapInMessageSend.
	self assert: message selector isEmpty.
	self assert: editor currentInput = message messageParts first.
	message messageParts first keyStroke: (self keyboardEvent: $+).
	self assert: message selector = '+'.
	self assert: message arguments size = 1.
	self assert: editor currentInput = message messageParts first.
	message messageParts first keyStroke: (self keyboardEvent: $-).
	self assert: message selector = '+-'.
	message messageParts first keyStroke: (self keyboardEvent: $').
	self assert: editor currentInput = message arguments first.
	self assert: message selector = '+-'