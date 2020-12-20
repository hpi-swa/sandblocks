as yet unclassified
lookupAction: aSymbol

	^ (self behavior class lookupSelector: aSymbol) ifNil: [self class lookupSelector: aSymbol]