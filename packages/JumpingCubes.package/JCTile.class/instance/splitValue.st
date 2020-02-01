as yet unclassified
splitValue

	value := value - self neighboringTiles size.
	self neighboringTiles do: [:tile | tile incrementValue]