as yet unclassified
popIntoTemporaryVariable: offset 

	store report: currentContext method pc: currentContext previousPc.
	^ super popIntoTemporaryVariable: offset