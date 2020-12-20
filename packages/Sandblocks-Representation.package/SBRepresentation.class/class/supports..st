as yet unclassified
supports: aSymbol

	^ (self respondsTo: aSymbol) and: [self perform: aSymbol]