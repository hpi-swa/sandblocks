as yet unclassified
previousBlock

	^ (self adjacentBlock: -1)
			ifNil: [self parentSandblock]
			ifNotNil: [:adj | adj rightMostBlock]