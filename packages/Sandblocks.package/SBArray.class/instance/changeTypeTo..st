as yet unclassified
changeTypeTo: aSymbol

	self sandblockEditor do: (SBMutatePropertyCommand new
		target: self;
		selector: #type;
		value: aSymbol)