as yet unclassified
testNestedOptionalWrap

	| doc a b c |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand morph data: (a := Morph new).
		SBAlgebraCommand softLine.
		SBAlgebraCommand group data: {
			SBAlgebraCommand morph data: (b := Morph new).
			SBAlgebraCommand softLine.
			SBAlgebraCommand morph data: (c := Morph new)}}.
	
	"SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 0 @ 0 equals: a position.
	self assert: a width @ 0 equals: b position.
	self assert: a width + b width @ 0 equals: c position."
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + 1.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position.
	self assert: 0 @ (a height + b height) equals: c position.
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + b width + 1.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position.
	self assert: a width @ (a height) equals: c position