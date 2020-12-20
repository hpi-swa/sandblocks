as yet unclassified
testInsertMessagePartBeforeEnd

	| message |
	message := 'a do: b' parseAsSandblock.
	self editorFor: message.
	message messageParts last insertElementAfter.
	self assert: message selector = 'do::'.
	self assert: message arguments first isUnknown