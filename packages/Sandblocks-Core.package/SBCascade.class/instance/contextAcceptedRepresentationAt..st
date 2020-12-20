as yet unclassified
contextAcceptedRepresentationAt: aNumber

	aNumber = 1 ifTrue: [^ #isSmalltalkExpression].
	^ #isSmalltalkMessage