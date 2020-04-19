as yet unclassified
stepOver

	| newContext |
	newContext := process completeStep: self currentStackFrame context.
	newContext == self currentStackFrame context ifTrue: [newContext := process stepToSendOrReturn].
	self resetContext: newContext