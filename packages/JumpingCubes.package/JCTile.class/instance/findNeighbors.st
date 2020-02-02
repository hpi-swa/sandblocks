as yet unclassified
findNeighbors

	neighbors := {(1 @ 0). (0 @ 1). (0 @ -1). (-1 @ 0)} collect: [:offset | self owner tileAt: self tilePosition + offset] thenSelect: #notNil.
	splitAE := SBWatch report: (SBSynchronousActiveExpression on: [value > self neighborCount]) for: 661189568.
	splitAE onChangeDo: [:shouldSplit | shouldSplit ifTrue: [self splitValue]].
	valueAE := SBWatch report: (SBSynchronousActiveExpression on: [value]) for: 26904944.
	valueAE onChangeDo: [:val | label contents: val asString]