actions
browseSenders
	<action>

	self selector ifNotNil: [:sel | | calls container |
		calls := self systemNavigation allCallsOn: sel asSymbol.
		calls ifEmpty: [^ self].
		calls size = 1 ifTrue: [^ self sandblockEditor open: calls first compiledMethod].
		
		container := SBCodeAccordion new.
		calls do: [:call | container  addMorphBack: (SBCodeLens forMethod: call compiledMethod selector: sel)].
		container openNear: self]