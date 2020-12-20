as yet unclassified
doubleClick: anEvent

	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact) replacer: self expression; target: self)