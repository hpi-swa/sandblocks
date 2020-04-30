as yet unclassified
methodReturnConstant: value 

	store report: currentContext method homeMethod pc: currentContext previousPc.
	^ super methodReturnConstant: value