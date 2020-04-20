as yet unclassified
stepOver

	| newContext currentBlock |
	currentBlock := self currentStackFrame currentBlock.
	newContext := process completeStep: self currentStackFrame context.
	
	newContext = self currentStackFrame context
		ifTrue: [
			self currentStackFrame recordTopValueFor: currentBlock.
			newContext := process stepToSendOrReturn].
	
	self resetContext: newContext