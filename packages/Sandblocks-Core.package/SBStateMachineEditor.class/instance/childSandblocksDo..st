as yet unclassified
childSandblocksDo: aBlock

	self states do: [:state | aBlock value: state].
	self connectors do: [:transition | aBlock value: transition conditions]