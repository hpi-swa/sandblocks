as yet unclassified
createFrameForContext: aContext

	^ SBErrorStackFrame new
		context: aContext;
		when: #selected send: #currentStackFrame: to: self