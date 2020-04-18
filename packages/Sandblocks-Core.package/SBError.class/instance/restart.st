as yet unclassified
restart

	process popTo: self currentStackFrame context.
	[self firstSubmorph ~= self currentStackFrame] whileTrue: [self removeMorph: self firstSubmorph].
	process
		restartTop;
		stepToSendOrReturn.
	self currentStackFrame updateSelection