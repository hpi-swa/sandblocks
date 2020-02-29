accessing
childSandblocksDo: aBlock

	self submorphCount > 1 ifTrue: [aBlock value: self expression]