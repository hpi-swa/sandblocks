as yet unclassified
stepOver

	| newContext currentBlock |
	currentBlock := self currentBlockForPC.
	newContext := process completeStep: context.
	newContext == context ifTrue: [newContext := process stepToSendOrReturn].
	currentBlock ifNotNil: [:b | blockValues at: currentBlock put: newContext top].
	self updateTempVariableValues.
	
	self context: newContext