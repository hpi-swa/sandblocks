as yet unclassified
parentAdjacentBlock: aNumber

	^ (self adjacentBlock: aNumber)
		ifNil: [self parentSandblock ifNotNil: [:p | p parentAdjacentBlock: aNumber]]