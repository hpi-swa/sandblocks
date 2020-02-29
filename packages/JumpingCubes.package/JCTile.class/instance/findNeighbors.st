as yet unclassified
findNeighbors

	neighbors := {(0 @ 1). (-1 @ 0). (0 @ -1). (1 @ 0)} collect: [:offset | self owner tileAt: self tilePosition + offset] thenSelect: #notNil.
	splitAE := SBSynchronousActiveExpression on: [value > self neighborCount].
	splitAE onChangeDo: [:shouldSplit | shouldSplit ifTrue: [self splitValue]].
	valueAE := SBSynchronousActiveExpression on: [value].
	valueAE onChangeDo: [:val | label contents: val asString]