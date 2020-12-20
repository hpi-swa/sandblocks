as yet unclassified
previousFrom: aBlock

	^ aBlock hasChildSandblocks ifTrue: [aBlock childSandblocks last] ifFalse: [aBlock parentAdjacentBlock: -1]