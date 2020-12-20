as yet unclassified
testContainerBounds

	| doc a b container |
	doc := SBAlgebraCommand container
		morph: (container := Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap);
		data: {
			SBAlgebraCommand morph data: (a := Morph new extent: 80 @ 40).
			SBAlgebraCommand hardLine.
			SBAlgebraCommand morph data: (b := Morph new)}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ 40 equals: b position.
	self assert: 80 @ 80 equals: container extent