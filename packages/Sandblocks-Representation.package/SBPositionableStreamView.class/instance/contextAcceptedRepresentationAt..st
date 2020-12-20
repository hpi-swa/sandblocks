as yet unclassified
contextAcceptedRepresentationAt: aNumber

	^ aNumber < (self childSandblocks size - 2) ifTrue: [#isSandblock] ifFalse: [nil]