as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	" ignore requests to input and instead interpret them as intent to swap the boolean "
	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingMethod)
		target: self;
		selector: #contents;
		value: self parsedContents not asString;
		yourself).
	
	^ nil