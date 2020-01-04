as yet unclassified
colored: aColor after: anObject

	SBDisplayActiveExpressionMarbles allInstancesDo: [:marbles | marbles isInWorld ifTrue: [marbles addSyncEvent: aColor]].
	^ aColor