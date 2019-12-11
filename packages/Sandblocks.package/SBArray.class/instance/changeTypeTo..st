as yet unclassified
changeTypeTo: aSymbol

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingMethod)
		target: self;
		selector: #type;
		value: aSymbol)