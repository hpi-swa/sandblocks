as yet unclassified
changeHeadingLevel: aNumber

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
		target: self;
		selector: #headingLevel;
		value: aNumber)