hierarchy
allBlocksSelect: aBlock

	^ Array streamContents: [:stream |
		self allBlocksDo: [:b | (aBlock value: b) ifTrue: [stream nextPut: b]]]