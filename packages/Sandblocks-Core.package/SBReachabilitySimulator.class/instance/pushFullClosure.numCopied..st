as yet unclassified
pushFullClosure: aCompiledBlock numCopied: numCopied

	store report: currentContext method pc: currentContext previousPc.
	^ super pushFullClosure: aCompiledBlock numCopied: numCopied