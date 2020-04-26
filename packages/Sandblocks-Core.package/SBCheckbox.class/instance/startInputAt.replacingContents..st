as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
		target: self;
		selector: #value;
		value: self value not).
	
	self triggerEvent: #toggled.
	^ nil