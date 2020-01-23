as yet unclassified
popIntoReceiverVariable: offset

	(tempObjects anySatisfy: [:obj | obj == currentContext receiver]) ifFalse: [
		sideEffects add: {currentContext receiver. SBCodeContext for: currentContext}].
	
	^ currentContext popIntoReceiverVariable: offset