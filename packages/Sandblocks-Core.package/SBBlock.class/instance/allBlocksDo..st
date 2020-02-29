accessing
allBlocksDo: aBlock

	self childSandblocksDo: [:m | m allBlocksDo: aBlock].
	aBlock value: self