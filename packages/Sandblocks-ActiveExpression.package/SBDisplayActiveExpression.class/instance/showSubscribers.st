as yet unclassified
showSubscribers

	| lenses |
	lenses := Array streamContents: [:stream |
		expression callbacks do: [:cb | cb ~= callback ifTrue: [
			stream nextPut: (SBCodeLens forContext: ((SBCodeContext for: cb outerContext) pc: cb startpc - 4))]]].
	lenses ifNotEmpty: [SBCodeAccordion new addAllMorphs: lenses; openNear: self containingSandblock]