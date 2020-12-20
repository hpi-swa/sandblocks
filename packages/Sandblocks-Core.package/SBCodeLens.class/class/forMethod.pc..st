as yet unclassified
forMethod: aCompiledMethod pc: aNumber

	| methodBlock |
	methodBlock := aCompiledMethod asSandblock.
	^ self new
		method: methodBlock;
		fullBounds;
		focus: (methodBlock blockForPC: aNumber);
		yourself