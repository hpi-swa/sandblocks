as yet unclassified
findNeighbors

	neighbors := {(0 @ 1). (-1 @ 0). (0 @ -1). (1 @ 0)}
		collect: [:offset | self owner tileAt: self tilePosition + (SBWatch report: offset for: 874434846)]
		thenSelect: #notNil.
	splitAE := SBWatch report: (SBSynchronousActiveExpression on: [value > self neighborCount]) for: 387606253.
	splitAE onChangeDo: [:shouldSplit | shouldSplit ifTrue: [self splitValue]].
	valueAE := SBWatch report: (SBSynchronousActiveExpression on: [value]) for: 683507325.
	valueAE onChangeDo: [:val | label contents: val asString]