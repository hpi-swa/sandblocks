as yet unclassified
childSandblocksDo: aBlock

	states do: [:state | aBlock value: state].
	connectors do: [:transition | transition conditions do: [:condition | aBlock value: condition]]