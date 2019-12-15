as yet unclassified
forMethod: aCompiledMethod selector: aSymbol

	| methodBlock |
	methodBlock := aCompiledMethod asSandblock.
	^ self new
		method: methodBlock;
		fullBounds;
		focus: (methodBlock blockForSelector: aSymbol);
		yourself