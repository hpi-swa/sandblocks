as yet unclassified
changeHeadingLevel: aNumber

	self sandblockEditor do: (SBMutatePropertyCommand new
		target: self;
		selector: #headingLevel;
		value: aNumber)