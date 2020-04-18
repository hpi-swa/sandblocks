as yet unclassified
stepInto

	| newContext |
	process step: self currentStackFrame context.
	newContext := process stepToSendOrReturn.
	newContext == self currentStackFrame context
		ifTrue: [self currentStackFrame updateSelection]
		ifFalse: [
			self addMorphFront: (self createFrameForContext: newContext).
			self firstSubmorph select]