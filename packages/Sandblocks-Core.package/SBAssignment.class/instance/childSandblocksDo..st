converting
childSandblocksDo: aBlock

	self hasSubmorphs ifTrue: [
		aBlock value: self firstSubmorph.
		aBlock value: self lastSubmorph]