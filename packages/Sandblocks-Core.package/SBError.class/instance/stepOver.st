as yet unclassified
stepOver

	| newContext |
	newContext := process completeStep: self currentStackFrame context.
	newContext == self currentStackFrame context
		ifTrue: [
			process stepToSendOrReturn.
			self currentStackFrame updateSelection]
		ifFalse: [
			self removeMorph: self firstSubmorph.
			self firstSubmorph select]