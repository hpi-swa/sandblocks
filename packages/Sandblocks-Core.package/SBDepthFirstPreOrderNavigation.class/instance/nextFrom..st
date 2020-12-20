as yet unclassified
nextFrom: aBlock

	aBlock childSandblocksDo: [:first | ^ first].
	^ (aBlock adjacentBlock: 1) ifNil: [aBlock parentSandblock parentAdjacentBlock: 1]