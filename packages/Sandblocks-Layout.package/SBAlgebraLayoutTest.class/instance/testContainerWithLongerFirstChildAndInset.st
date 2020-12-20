as yet unclassified
testContainerWithLongerFirstChildAndInset

	| doc container |
	doc := SBAlgebraCommand container
		morph: (container := Morph new layoutInset: 10; hResizing: #shrinkWrap; vResizing: #shrinkWrap);
		data: {
			SBAlgebraCommand morph data: (Morph new width: 80).
			SBAlgebraCommand hardLine.
			SBAlgebraCommand morph data: (Morph new width: 40)
		}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 500.
	self assert: 100 equals: container width