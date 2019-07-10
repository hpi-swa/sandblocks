*Sandblocks
allMorphsDoBreadthFirst: aBlock

	aBlock value: self.
	self submorphsDo: [:m | m allMorphsDoBreadthFirst: aBlock]