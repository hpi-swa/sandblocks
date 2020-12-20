*Sandblocks-Core
representationsThat: aSymbol

	^ (Array streamContents: [:stream |
		self representationsThat: aSymbol do: [:repr | stream nextPut: repr]]) sort: #priority asSortFunction reversed.