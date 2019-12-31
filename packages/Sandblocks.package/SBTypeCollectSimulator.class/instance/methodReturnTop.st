as yet unclassified
methodReturnTop

	self reportTypeInfo: currentContext top at: currentContext methodReturnContext.
	Transcript  showln: {currentContext top. currentContext methodReturnContext}.
	^ currentContext methodReturnTop