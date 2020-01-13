accessing
useAsVariable

	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: (SBBinding new contents: self selector))