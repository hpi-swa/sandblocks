callbacks
showSubscribersOf: anExpression

	| lenses |
	lenses := Array streamContents: [:stream |
		anExpression callbacks do: [:cb | cb ~= (expressions at: anExpression) ifTrue: [
			" block declare comes 4 bytes before block's startpc "
			stream nextPut: (SBCodeLens forContext: ((SBCodeContext for: cb outerContext) pc: cb startpc - 4))]]].
	lenses ifNotEmpty: [SBCodeAccordion new addAllMorphs: lenses; openNear: self containingSandblock]