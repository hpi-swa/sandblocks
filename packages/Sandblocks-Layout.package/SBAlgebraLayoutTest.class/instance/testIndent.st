as yet unclassified
testIndent

	| doc a b |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand morph data: (a := Morph new).
		SBAlgebraCommand indent data: {
			SBAlgebraCommand softLine.
			SBAlgebraCommand morph data: (b := Morph new)}}.
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + 21.
	self assert: 0 @ 0 equals: a position.
	self assert: 20 @ a height equals: b position