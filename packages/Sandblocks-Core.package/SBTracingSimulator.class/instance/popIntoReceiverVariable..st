as yet unclassified
popIntoReceiverVariable: offset

	(tempObjects includes: currentContext receiver) ifFalse: [
		sideEffects add: {currentContext receiver. SBCodeContext for: currentContext}].
	
	^ currentContext popIntoReceiverVariable: offset