hierarchy
allBlocks

	^ Array streamContents: [:stream | self allBlocksDo: [:block | stream nextPut: block]]