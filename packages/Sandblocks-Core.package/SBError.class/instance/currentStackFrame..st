as yet unclassified
currentStackFrame: aFrameBlock

	currentStackFrame ifNotNil: [currentStackFrame closed].
	currentStackFrame := aFrameBlock