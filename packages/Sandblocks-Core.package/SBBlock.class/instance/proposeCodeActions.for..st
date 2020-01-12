as yet unclassified
proposeCodeActions: aCollection for: aBlock

	| index |
	index := UIManager default chooseFrom: (aCollection collect: #label).
	index > 0 ifTrue: [(aCollection at: index) do]