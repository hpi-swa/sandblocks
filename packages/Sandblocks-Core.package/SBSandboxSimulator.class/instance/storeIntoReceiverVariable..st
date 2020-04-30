as yet unclassified
storeIntoReceiverVariable: offset

	(tempObjects includes: currentContext receiver) ifFalse: [^ SBExampleWatch report: nil for: 35168154].
	^ super storeIntoReceiverVariable: offset