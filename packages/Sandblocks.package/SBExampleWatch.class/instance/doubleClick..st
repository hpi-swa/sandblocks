as yet unclassified
doubleClick: anEvent

	self sandblockEditor do: (SBReplaceCommand new replacer: self expression; target: self)