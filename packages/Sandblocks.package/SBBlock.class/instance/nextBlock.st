as yet unclassified
nextBlock

	^ self childSandblocks
		ifNotEmpty: #first
		ifEmpty: [
			(self adjacentBlock: 1) ifNil: [
				self parentSandblock parentAdjacentBlock: 1]]