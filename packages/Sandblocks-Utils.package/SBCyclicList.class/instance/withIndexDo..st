as yet unclassified
withIndexDo: aBlock

	| index |
	index := 1.
	self do: [:value | aBlock value: value value: index.
		index := index + 1]