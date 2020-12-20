as yet unclassified
testContainerLeftInset

	| doc a b container |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand container
			morph: (container := Morph new layoutInset: (SBEdgeInsets left: 10); hResizing: #shrinkWrap; vResizing: #shrinkWrap);
			data: {SBAlgebraCommand morph data: (a := Morph new)}.
		SBAlgebraCommand hardLine.
		SBAlgebraCommand morph data: (b := Morph new)}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 60 @ 40 equals: container extent.
	self assert: 10 @ 0 equals: a position.
	self assert: 0 @ 40 equals: b position