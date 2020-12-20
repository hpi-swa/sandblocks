as yet unclassified
contextAcceptedRepresentationAt: aNumber

	| base |
	base := self isInCascade ifTrue: [0] ifFalse: 1.
	aNumber = base ifTrue: [^ #isSmalltalkExpression].
	^ (aNumber + base) odd
		ifTrue: [#isSmalltalkMessagePart]
		ifFalse: [#isSmalltalkExpression]