as yet unclassified
popIntoReceiverVariable: offset

	(tempObjects includes: (SBExampleWatch report: currentContext for: 1050030447) receiver) ifFalse: [
		self currentContextIsWhiteListed ifFalse: [^ SBExampleWatch report: nil for: 605804066]].
	^ currentContext popIntoReceiverVariable: offset