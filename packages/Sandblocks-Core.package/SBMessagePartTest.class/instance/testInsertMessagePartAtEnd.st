as yet unclassified
testInsertMessagePartAtEnd

	| message |
	message := 'a do: b' parseAsSandblock.
	self editorFor: message.
	message arguments last insertElementAfter.
	self assert: message selector = 'do::'.
	self assert: message arguments last isUnknown