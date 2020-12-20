as yet unclassified
popIntoLiteralVariable: offset 

	store report: currentContext method pc: currentContext previousPc.
	^ super popIntoLiteralVariable: offset