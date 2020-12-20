as yet unclassified
foregroundColorForBlock: aBlock

	aBlock isLiteralBlock ifTrue: [ | c |
		c := Color r: 1 g: 0.748 b: 0.748.
		aBlock drawnColor luminance > 0.7 ifTrue: [c := Color r: 0.718 g: 0.39 b: 0.39].
		^ c].
	aBlock isName ifTrue: [ | c |
		c := Color r: 0.731 g: 0.826 b: 1.
		aBlock drawnColor luminance > 0.6 ifTrue: [c := Color r: 0.263 g: 0.263 b: 0.941].
		^ c].
	^ self foregroundColorForColor: aBlock drawnColor