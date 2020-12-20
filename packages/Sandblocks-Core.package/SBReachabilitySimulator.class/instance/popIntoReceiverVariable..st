as yet unclassified
popIntoReceiverVariable: offset 

	store report: currentContext method pc: currentContext previousPc.
	^ super popIntoReceiverVariable: offset