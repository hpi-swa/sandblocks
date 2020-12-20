as yet unclassified
createFrameForContext: aContext

	| frame |
	frame := SBErrorStackFrame new context: aContext.
	frame when: #selected send: #currentStackFrame: to: self with: frame.
	
	^ frame