as yet unclassified
testIndentDifferentOrigin

	| doc a b |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand morph data: (a := Morph new).
		SBAlgebraCommand indent data: {
			SBAlgebraCommand softLine.
			SBAlgebraCommand morph data: (b := Morph new)}}.
	
	SBAlgebraLayout new layoutDocument: doc at: ((SBAlgebraState new offset: 30 @ 20) startX: 30) limit: a width + 21 wrap: false.
	self assert: 30 @ 20 equals: a position.
	self assert: (30 @ 20) + (20 @ a height) equals: b position