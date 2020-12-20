*Sandblocks-Core
hasDerivableRepresentationThat: aSymbol

	self representationsThat: aSymbol do: [:repr | repr isLeaf ifFalse: [^ true]] deep: false.
	^ false