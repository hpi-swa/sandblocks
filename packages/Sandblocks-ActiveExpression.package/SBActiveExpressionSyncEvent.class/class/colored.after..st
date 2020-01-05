as yet unclassified
colored: aColor after: anObject

	| subject |
	subject := thisContext sender receiver.
	SBDisplayActiveExpressionMarbles allInstancesDo: [:marbles |
		marbles isInWorld ifTrue: [
			marbles addSyncEvent: aColor from: subject with: anObject]].
	^ anObject