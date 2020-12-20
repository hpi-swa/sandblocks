as yet unclassified
foregroundColorForBlock: aBlock

	aBlock isLiteralBlock ifTrue: [^ Color r: 0.8 g: 0 b: 0].
	aBlock isName ifTrue: [^ Color r: 0.263 g: 0.263 b: 0.941].
	
	^ self foregroundColorForColor: aBlock drawnColor