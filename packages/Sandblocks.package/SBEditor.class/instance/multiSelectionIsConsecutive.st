selection
multiSelectionIsConsecutive

	| sorted |
	sorted := self sortedMultiSelection.
	sorted overlappingPairsDo: [:a :b |
		a submorphAfter = b ifFalse: [^ false]].
	^ true