as yet unclassified
newForStack: aCollection

	| y accordion |
	accordion := self new.
	y := 0.
	aCollection do: [:context | | methodBlock |
		methodBlock := SBCodeLens forContext: context.
		methodBlock fullBounds.
		accordion addMorphBack: methodBlock.
		methodBlock position: 0 @ y.
		y := y + methodBlock height].
	
	^ accordion