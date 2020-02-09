as yet unclassified
allBlocksDo: aBlock

	self childSandblocksDo: [:m | m allBlocksDo: aBlock].
	aBlock value: self