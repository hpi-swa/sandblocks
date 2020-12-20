as yet unclassified
methodReturnConstant: value 

	self reportTypeInfo: value at: currentContext methodReturnContext sender.
	^ currentContext methodReturnConstant: value