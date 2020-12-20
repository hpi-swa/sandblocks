as yet unclassified
previousFrom: aBlock

	^ (aBlock adjacentBlock: -1) ifNil: [aBlock parentSandblock] ifNotNil: [:adj | adj rightMostBlock]