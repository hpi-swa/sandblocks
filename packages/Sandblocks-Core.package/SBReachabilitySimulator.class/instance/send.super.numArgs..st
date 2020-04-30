as yet unclassified
send: selector super: supered numArgs: numArgs

	store report: currentContext method homeMethod pc: currentContext previousPc.
	^ super send: selector super: supered numArgs: numArgs