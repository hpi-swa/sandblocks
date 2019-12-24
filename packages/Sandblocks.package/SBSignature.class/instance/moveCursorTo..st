as yet unclassified
moveCursorTo: aNumber

	| index |
	index := 0.
	self submorphs pairsDo: [:message :argument |
		index := index + message contents size.
		index >= aNumber
			ifTrue: [
				currentInputMessagePart := message.
				currentInputMessagePart moveCursorTo: aNumber - index - message contents size.
				^ self]].
	
	currentInputMessagePart := self submorphs at: (self submorphCount - 1 max: 1).
	currentInputMessagePart moveCursorTo: aNumber