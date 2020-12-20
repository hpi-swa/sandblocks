as yet unclassified
childSandblocksDo: aBlock

	comment owner
		ifNotNil: [aBlock value: comment].
	
	self optionRows do: [:b | b submorphsDo: aBlock]