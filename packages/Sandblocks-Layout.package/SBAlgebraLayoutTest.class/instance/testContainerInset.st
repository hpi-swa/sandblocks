as yet unclassified
testContainerInset

	| doc a b container |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand container
			morph: (container := Morph new layoutInset: 10; hResizing: #shrinkWrap; vResizing: #shrinkWrap);
			data: {SBAlgebraCommand morph data: (a := Morph new)}.
		SBAlgebraCommand hardLine.
		SBAlgebraCommand morph data: (b := Morph new)}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 70 @ 60 equals: container extent.
	self assert: 10 @ 10 equals: a position.
	self assert: 0 @ 60 equals: b position