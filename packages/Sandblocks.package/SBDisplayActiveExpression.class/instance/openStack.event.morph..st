as yet unclassified
openStack: aCollectionOfStackDefs event: anEvent morph: aMorph

	| editor y accordion |
	editor := self sandblockEditor.
	
	accordion := SBCodeAccordion new.
	y := 0.
	aCollectionOfStackDefs do: [:context | | methodBlock |
		methodBlock := SBCodeLens forContext: context.
		methodBlock fullBounds.
		accordion addMorphBack: methodBlock.
		methodBlock position: 0 @ y.
		y := y + methodBlock height].
	
	accordion position: aMorph right + 40 @ aMorph top.
	editor openMorph: accordion