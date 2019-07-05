as yet unclassified
allBlocksDo: aBlock

	self childSandblocks do: [:m | m allBlocksDo: aBlock].
	aBlock value: self