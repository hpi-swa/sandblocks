as yet unclassified
popIntoReceiverVariable: offset

	(tempObjects includes: currentContext receiver) ifFalse: [self currentContextIsWhiteListed ifFalse: [^ SBExampleWatch report: nil for: 605804066]].
	^ currentContext popIntoReceiverVariable: offset