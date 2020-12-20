as yet unclassified
stepThrough

	| newContext currentBlock |
	currentBlock := self currentBlock.
	process stepToHome: self currentStackFrame context.
	newContext := process stepToSendOrReturn.
	
	newContext = self currentStackFrame context
		ifTrue: [
			self currentStackFrame recordTopValueFor: currentBlock.
			newContext := process stepToSendOrReturn].
	
	self resetContext: newContext