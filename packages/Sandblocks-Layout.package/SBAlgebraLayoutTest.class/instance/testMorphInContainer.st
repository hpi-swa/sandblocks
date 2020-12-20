as yet unclassified
testMorphInContainer

	| doc a container innerContainer |
	doc := SBAlgebraCommand container
		morph: (container := Morph new position: 100 @ 100; layoutInset: 10; hResizing: #shrinkWrap; vResizing: #shrinkWrap; yourself);
		data: {
			SBAlgebraCommand container
				morph: (Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap);
				data: {SBAlgebraCommand morph data: (Morph new extent: 30 @ 30)}.
			SBAlgebraCommand hardLine.
			SBAlgebraCommand container
				morph: (innerContainer := Morph new layoutInset: 10; hResizing: #shrinkWrap; vResizing: #shrinkWrap);
				data: {SBAlgebraCommand morph data: (a := Morph new extent: 50 @ 50)}}.
	
	SBAlgebraLayout new
		layoutDocument: doc
		at: ((SBAlgebraState new offset: container position) startX: container left)
		limit: 300
		wrap: false.
	
	self assert: 90 @ 120 equals: container extent.
	self assert: 100 @ 100 equals: container position.
	self assert: 120 @ 150 equals: a position