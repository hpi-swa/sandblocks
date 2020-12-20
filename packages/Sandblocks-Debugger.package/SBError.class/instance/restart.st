as yet unclassified
restart

	| actualContext targetContext |
	targetContext := self currentStackFrame context.
	actualContext := process popTo: targetContext.
	
	actualContext = targetContext ifTrue: [
		process
			restartTop;
			stepToSendOrReturn].
	
	self resetContext: actualContext