as yet unclassified
splitValue

	self neighboringTiles do: [:tile | tile incrementValue].
	value := value - self neighboringTiles size