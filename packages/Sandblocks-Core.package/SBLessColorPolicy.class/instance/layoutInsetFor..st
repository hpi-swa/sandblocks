as yet unclassified
layoutInsetFor: aBlock

	aBlock isBlockBody ifTrue: [^ 2 @ 1].
	aBlock isMessageSend ifFalse: [^ 2 @ 0].
	aBlock childSandblocksDo: [:child |
		(child isMessageSend and: [child precedence > aBlock precedence or: [aBlock precedence = 3 and: [child precedence = 3]]]) ifTrue: [^ 2 @ 10]].
	^ 2 @ 0