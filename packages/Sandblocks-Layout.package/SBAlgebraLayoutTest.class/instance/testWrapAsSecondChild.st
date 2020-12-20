as yet unclassified
testWrapAsSecondChild

	| doc a b c |
	doc := SBAlgebraCommand container
		morph: (Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap);
		data: {
			SBAlgebraCommand container morph: (a := Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap); data: {SBAlgebraCommand morph data: (Morph new extent: 50 @ 20)}.
			SBAlgebraCommand container
				morph: (Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap);
				data: {
					SBAlgebraCommand container
						morph: Morph new;
						data: {
							SBAlgebraCommand morph data: (b := Morph new extent: 50 @ 20)}.
							SBAlgebraCommand softLine.
							SBAlgebraCommand morph data: (c := Morph new extent: 50 @ 20)}}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 80.
	
	self assert: 0 @ 0 equals: a position.
	self assert: 50 @ 0 equals: b position.
	self assert: 50 @ 20 equals: c position