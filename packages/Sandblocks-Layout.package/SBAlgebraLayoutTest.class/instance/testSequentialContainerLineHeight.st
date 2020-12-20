as yet unclassified
testSequentialContainerLineHeight

	| doc a b |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand container morph: (a := Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap); data: {SBAlgebraCommand morph data: (Morph new extent: 10 @ 80)}.
		SBAlgebraCommand container morph: (b := Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap); data: {SBAlgebraCommand morph data: (Morph new extent: 10 @ 30)}}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 10 @ 80 equals: a extent.
	self assert: 10 @ 30 equals: b extent