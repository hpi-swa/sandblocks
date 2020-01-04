accessing
openStack

	| editor y accordion |
	editor := self sandblockEditor.
	
	accordion := SBCodeAccordion new.
	y := 0.
	self stack do: [:context | | methodBlock |
		methodBlock := SBCodeLens forContext: context.
		methodBlock fullBounds.
		accordion addMorphBack: methodBlock.
		methodBlock position: 0 @ y.
		y := y + methodBlock height].
	
	accordion openNear: self containingSandblock