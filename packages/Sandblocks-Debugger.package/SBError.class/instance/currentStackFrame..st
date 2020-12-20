as yet unclassified
currentStackFrame: aFrameBlock

	(currentStackFrame notNil and: [currentStackFrame ~= aFrameBlock]) ifTrue: [currentStackFrame closed].
	currentStackFrame := aFrameBlock.
	
	Project current addDeferredUIMessage: [scroll scrollToShow: (aFrameBlock bounds expandBy: 0 @ 60 withScalingFactor)].
	
	self updateExplorers