as yet unclassified
toggle

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingMethod)
		target: self;
		selector: #contents;
		value: self parsedContents not asString;
		yourself).
	self triggerEvent: #toggled