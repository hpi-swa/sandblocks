as yet unclassified
allUsages

	^ Array streamContents: [:stream |
		self allUsagesDo: [:u | stream nextPut: u]]