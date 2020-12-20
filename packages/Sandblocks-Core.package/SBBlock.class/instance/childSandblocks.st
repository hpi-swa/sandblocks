hierarchy
childSandblocks

	^ Array streamContents: [:stream | self childSandblocksDo: [:block | stream nextPut: block]]