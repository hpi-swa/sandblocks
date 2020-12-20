as yet unclassified
childSandblocksDo: aBlock

	aBlock value: classPrefix.
	signature childSandblocksDo: aBlock.
	self body visible ifTrue: [aBlock value: self body]