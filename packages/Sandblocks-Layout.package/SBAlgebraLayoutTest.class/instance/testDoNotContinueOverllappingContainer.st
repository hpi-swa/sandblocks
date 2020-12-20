as yet unclassified
testDoNotContinueOverllappingContainer

	| doc a b c |
	doc :=  SBAlgebraCommand container
		morph: Morph new;
		data: {
			SBAlgebraCommand container
				morph: Morph new;
				data: {
					SBAlgebraCommand morph data: (a := Morph new extent: 200 @ 40).
					SBAlgebraCommand group data: {
						SBAlgebraCommand softLineOrGap data: false.
						SBAlgebraCommand container morph: Morph new; data: {SBAlgebraCommand morph data: (b := Morph new)}}}.
			SBAlgebraCommand group data: {
				SBAlgebraCommand softLineOrGap data: false.
				SBAlgebraCommand container
					morph: Morph new;
					data: {SBAlgebraCommand morph data: (c := Morph new)}}}.
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + 30.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position.
	self assert: 0 @ (a height + b height) equals: c position