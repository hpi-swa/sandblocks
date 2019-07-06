as yet unclassified
valid

	^ self validContents and: [self isDeclaration or: [self validBinding]]