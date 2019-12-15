as yet unclassified
browseSenders

	self selector ifNotNil: [:sel | | calls container |
		calls := self systemNavigation allCallsOn: sel asSymbol.
		container := SBCodeAccordion new.
		calls do: [:call |
			container  addMorphBack: (SBCodeLens forMethod: call compiledMethod selector: sel)].
		container openNear: self]