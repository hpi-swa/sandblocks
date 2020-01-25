as yet unclassified
findNeighbors

	SBExample self: [JCTile new] args: [{}] label: 'simple'.
	neighbors := {(1 @ 0). (0 @ 1). (0 @ -1). (-1 @ 0)} collect: [:offset | self owner tileAt: self tilePosition + offset] thenSelect: #notNil.
	splitAE := SBWatch report: (SBSynchronousActiveExpression on: [value > self neighboringTiles size]) for: 943297629.
	splitAE onChangeDo: [:shouldSplit | shouldSplit ifTrue: [self splitValue]].
	valueAE := SBWatch report: (SBSynchronousActiveExpression on: [value]) for: 905102816.
	valueAE onChangeDo: [:val | label contents: val asString]