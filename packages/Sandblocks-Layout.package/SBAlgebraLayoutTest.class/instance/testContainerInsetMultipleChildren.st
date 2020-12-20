as yet unclassified
testContainerInsetMultipleChildren

	| doc a b container |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand container
			morph: (container := Morph new layoutInset: 30; hResizing: #shrinkWrap; vResizing: #shrinkWrap);
			data: {
				SBAlgebraCommand morph data: (a := Morph new).
				SBAlgebraCommand hardLine.
				SBAlgebraCommand morph data: (b := Morph new)}}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 30 @ 30 equals: a position.
	self assert: 30 @ 70 equals: b position.
	self assert: 110 @ 140 equals: container extent