as yet unclassified
nextFrom: aBlock

	^ (aBlock adjacentBlock: 1) ifNotNil: [:b | b firstDeepChild] ifNil: [aBlock parentSandblock]