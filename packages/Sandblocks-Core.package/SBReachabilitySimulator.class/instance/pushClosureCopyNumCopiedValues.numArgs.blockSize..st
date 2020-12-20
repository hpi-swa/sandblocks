as yet unclassified
pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize

	store report: currentContext method pc: currentContext previousPc.
	^ super pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize