as yet unclassified
doubleClick: anEvent

	self sandblockEditor do: ((SBReplaceCommand newFor: self containingMethod) replacer: self expression; target: self)