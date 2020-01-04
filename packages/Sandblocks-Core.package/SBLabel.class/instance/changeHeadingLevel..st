as yet unclassified
changeHeadingLevel: aNumber

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingMethod)
		target: self;
		selector: #headingLevel;
		value: aNumber)