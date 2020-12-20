*Sandblocks-Core
representations

	^ Array streamContents: [:stream |
		self representationsDo: [:class | stream nextPut: class]]