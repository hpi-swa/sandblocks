as yet unclassified
findNeighbors

	neighbors := {(1 @ 0). (0 @ 1). (0 @ -1). (-1 @ 0)} collect: [:offset | self owner tileAt: self tilePosition + offset] thenSelect: #notNil.
	splitAE := SBWatch report: (SBSynchronousActiveExpression on: [value > self neighborCount]) for: 224021914.
	splitAE onChangeDo: [:shouldSplit | shouldSplit ifTrue: [self splitValue]].
	valueAE := SBWatch report: (SBSynchronousActiveExpression on: [value]) for: 720782734.
	valueAE onChangeDo: [:val | label contents: val asString]