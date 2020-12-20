converting
contextAcceptedRepresentationAt: aNumber

	aNumber = 1 ifTrue: [^ #isSmalltalkName].
	^ #isSmalltalkExpression