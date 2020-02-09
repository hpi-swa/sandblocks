as yet unclassified
childSandblocksDo: aBlock

	aBlock value: text.
	examples owner ifNotNil: [examples submorphsDo: aBlock]