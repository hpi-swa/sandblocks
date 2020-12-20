as yet unclassified
testNestedOptionalWrap2

	| doc a b c |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand group data: {
			SBAlgebraCommand morph data: (a := Morph new).
			SBAlgebraCommand softLine.
			SBAlgebraCommand group data: {
				SBAlgebraCommand morph data: (b := Morph new).
				SBAlgebraCommand indent data: {
					SBAlgebraCommand softLine.
					SBAlgebraCommand group data: {
						SBAlgebraCommand morph data: (c := Morph new)}}}}}.
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + b width + 1.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position.
	self assert: b width @ a height equals: c position.
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + 21.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position.
	self assert: 20 @ (a height + b height) equals: c position