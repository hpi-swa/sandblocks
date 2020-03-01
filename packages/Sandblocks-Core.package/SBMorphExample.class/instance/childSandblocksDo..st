accessing
childSandblocksDo: aBlock

	aBlock value: self setUpMorph.
	self cases do: aBlock