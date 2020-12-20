as yet unclassified
testBasic

	| doc a b |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand morph data: (a := Morph new).
		SBAlgebraCommand morph data: (b := Morph new)}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	
	self assert: 0 @ 0 equals: a position.
	self assert: a width @ 0 equals: b position