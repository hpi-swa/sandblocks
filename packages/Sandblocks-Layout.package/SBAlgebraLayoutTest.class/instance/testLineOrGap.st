as yet unclassified
testLineOrGap

	| doc a b |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand morph data: (a := Morph new).
		SBAlgebraCommand softLineOrGap.
		SBAlgebraCommand morph data: (b := Morph new)}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 0 @ 0 equals: a position.
	self assert: a width + SBAlgebraLayout gap @ 0 equals: b position.
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + 1.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position