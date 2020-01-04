as yet unclassified
containingBlocksDo: aBlock

	| current |
	current := self containingBlock.
	[current] whileNotNil: [
		aBlock value: current.
		current := current containingBlock]