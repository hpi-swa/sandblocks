as yet unclassified
testInsertMessagePartAtStart

	| message |
	{[message receiver insertElementAfter]. [message messageParts first insertElementBefore]} do: [:cmd |
		message := 'a do: b' parseAsSandblock.
		self editorFor: message.
		cmd value.
		self assert: message selector = ':do:']