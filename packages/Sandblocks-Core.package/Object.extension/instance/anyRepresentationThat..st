*Sandblocks-Core
anyRepresentationThat: aSymbol

	| options |
	options := self representationsThat: aSymbol.
	options ifEmpty: [^ nil].
	^ self newFirstSafeOptionFrom: options