as yet unclassified
methodReturnConstant: value 

	store report: currentContext method pc: currentContext previousPc.
	^ super methodReturnConstant: value