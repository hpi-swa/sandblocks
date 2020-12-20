as yet unclassified
layoutInsetFor: aBlock

	| parent |
	aBlock isMessageSend ifFalse: [^ 2 @ 0].
	parent := aBlock parentSandblock.
	^ (parent isMessageSend and: [
			aBlock precedence > parent precedence or: [parent precedence = 3 and: [aBlock precedence = 3]]]) ifTrue: [2 @ 2] ifFalse: [2 @ 0]