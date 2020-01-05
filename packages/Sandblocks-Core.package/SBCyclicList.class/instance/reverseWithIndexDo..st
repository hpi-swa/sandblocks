as yet unclassified
reverseWithIndexDo: aBlock

	| index |
	index := 1.
	self reverseDo: [:value | aBlock value: value value: index.
		index := index + 1]