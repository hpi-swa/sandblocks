as yet unclassified
doubleClick: anEvent

	self sandblockEditor do: ((SBReplaceCommand newFor: self method) replacer: self expression; target: self)