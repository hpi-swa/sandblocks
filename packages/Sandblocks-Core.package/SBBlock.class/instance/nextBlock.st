hierarchy
nextBlock

	self childSandblocksDo: [:first | ^ first].
	
	^ (self adjacentBlock: 1) ifNil: [
		self parentSandblock parentAdjacentBlock: 1]