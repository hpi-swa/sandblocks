as yet unclassified
changeTypeTo: aSymbol

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
		target: self;
		selector: #type;
		value: aSymbol)