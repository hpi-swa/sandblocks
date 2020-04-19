as yet unclassified
searchFrom: aMorph ifNone: aBlock

	(aMorph nextBlockThat: [:m | self matchesQuery: m]) ifNotNil: [:m | self currentFocus: m] ifNil: aBlock