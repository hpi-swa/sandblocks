as yet unclassified
findNeighbors

	neighbors := {(1 @ 0). (0 @ 1). (0 @ -1). (-1 @ 0)} collect: [:offset | self owner tileAt: self tilePosition + offset] thenSelect: #notNil.
	splitAE := SBWatch report: (ActiveExpression on: [value > self neighboringTiles size]) for: 672688382.
	splitAE onChangeDo: [:shouldSplit | shouldSplit ifTrue: [self splitValue]].
	valueAE := SBWatch report: (ActiveExpression on: [value]) for: 11232299.
	valueAE onChangeDo: [:val | label contents: val asString]