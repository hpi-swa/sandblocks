as yet unclassified
currentStackFrame: aFrameBlock

	(currentStackFrame notNil and: [currentStackFrame ~= aFrameBlock]) ifTrue: [currentStackFrame closed].
	currentStackFrame := aFrameBlock.
	
	self updateExplorers