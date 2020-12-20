as yet unclassified
focusedContext

	self activeErrorDo: [:error | ^ error currentStackFrame context].
	^ nil