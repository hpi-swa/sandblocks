as yet unclassified
saveColor

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
		target: self;
		selector: #colorContents;
		value: self colorContents;
		oldValue: previousColor)