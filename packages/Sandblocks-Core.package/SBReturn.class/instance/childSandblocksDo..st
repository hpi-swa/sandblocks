formatting
childSandblocksDo: aBlock

	self hasSubmorphs ifTrue: [aBlock value: self firstSubmorph]