as yet unclassified
methodReturnConstant: value 

	self reportTypeInfo: value at: currentContext methodReturnContext.
	Transcript  showln: {value. currentContext methodReturnContext}.
	^ currentContext methodReturnConstant: value