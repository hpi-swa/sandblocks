as yet unclassified
identifier: aSymbol

	identifier := aSymbol.
	self world ifNotNil: [self class registerWatch: self]