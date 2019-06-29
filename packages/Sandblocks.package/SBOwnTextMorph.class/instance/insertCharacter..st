as yet unclassified
insertCharacter: aCharacter

	self cursor > self contents size
		ifTrue: [self contents: self contents, aCharacter]
		ifFalse: [self contents: (self contents first: self cursor - 1), aCharacter, (self contents allButFirst: self cursor - 1)].
	self moveCursorTo: self cursor + 1