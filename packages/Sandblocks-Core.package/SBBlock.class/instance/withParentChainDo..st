as yet unclassified
withParentChainDo: aBlock

	| p |
	p := aBlock.
	[aBlock] whileNotNil: [
		aBlock value: p.
		p := aBlock parentSandblock]