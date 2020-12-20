*Sandblocks-Core
hasRepresentationThat: aSymbol

	self representationsThat: aSymbol do: [:repr | ^ true] deep: 0.
	^ false