*Sandblocks-Core
representationThat: aSymbol

	^ self representationThat: aSymbol do: #yourself ifNone: [self error: 'no suitable representation found']