as yet unclassified
insertString: aString

	self cursor > self contents size
		ifTrue: [self contents: self contents, aString]
		ifFalse: [self contents: (self contents first: self cursor - 1), aString, (self contents allButFirst: self cursor - 1)].
	self moveCursorTo: self cursor + aString size