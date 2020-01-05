as yet unclassified
toggle

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
		target: self;
		selector: #contents;
		value: self parsedContents not asString;
		yourself).
	self triggerEvent: #toggled