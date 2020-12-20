as yet unclassified
toggleActive

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
		target: self;
		selector: #active;
		value: active not)