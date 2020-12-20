as yet unclassified
contextAcceptedRepresentationAt: aNumber

	aNumber = self childSandblocks size ifTrue: [^ #isSmalltalkBlock].
	^ #isSmalltalkName