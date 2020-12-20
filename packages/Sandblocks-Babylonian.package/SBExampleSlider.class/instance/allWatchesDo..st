as yet unclassified
allWatchesDo: aBlock

	self sandblockEditor allBlocksDo: [:block | block isExampleWatch ifTrue: [aBlock value: block]]