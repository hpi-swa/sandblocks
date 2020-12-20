as yet unclassified
stepInto

	| newContext |
	process step: self currentStackFrame context.
	newContext := process stepToSendOrReturn.
	self resetContext: newContext