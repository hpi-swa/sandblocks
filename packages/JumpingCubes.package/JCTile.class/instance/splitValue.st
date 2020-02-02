as yet unclassified
splitValue

	SBActiveExpressionSyncEvent after: (value := value - self neighboringTiles size).
	self neighboringTiles do: [:tile | tile incrementValue]