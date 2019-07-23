as yet unclassified
foregroundColorForBlock: aBlock

	"aBlock isLiteral ifTrue: [^ Color r: 0.6 g: 0 b: 0]."
	aBlock isName ifTrue: [^ nameColorCache at: aBlock contents ifAbsentPut: [self randomColor]].
	
	^ self foregroundColorForColor: aBlock drawnColor