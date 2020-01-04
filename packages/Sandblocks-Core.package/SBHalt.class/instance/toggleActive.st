as yet unclassified
toggleActive

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingMethod)
		target: self;
		selector: #active;
		value: active not)