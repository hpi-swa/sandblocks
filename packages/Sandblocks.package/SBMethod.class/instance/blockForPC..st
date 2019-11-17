as yet unclassified
blockForPC: aNumber

	"self allBlocksDo: [:m | m pc = aNumber ifTrue: [^ m]]."
	| sortedBlocks |
	sortedBlocks := ((Array streamContents: [:stream | self allBlocksDo: [:m | stream nextPut: m]])
		sorted: [:a :b | a pc < b pc]).
	sortedBlocks overlappingPairsDo: [:current :next |
			(aNumber between: current pc and: next pc - 1) ifTrue: [^ current]].
	^ sortedBlocks last