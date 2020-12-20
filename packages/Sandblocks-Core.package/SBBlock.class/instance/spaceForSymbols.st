as yet unclassified
spaceForSymbols

	| symbols |
	symbols := self symbols.
	^ {
		(symbols first ifNil: [0] ifNotNil: [self fontToUse widthOfString: symbols first]).
		(symbols second ifNil: [0] ifNotNil: [self fontToUse widthOfString: symbols second])
	}