as yet unclassified
storeIntoReceiverVariable: offset

	(tempObjects includes: currentContext receiver) ifFalse: [^ nil].
	^ super storeIntoReceiverVariable: offset