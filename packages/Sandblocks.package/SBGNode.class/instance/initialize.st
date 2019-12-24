as yet unclassified
initialize
	super initialize.
	self color: Color white.
	self addMorphBack: (outputs := SBColumn new).
	outputsAE := ManualActiveExpression
				on: [outputs].
	self addMorphBack: (inputs := SBColumn new).
	inputsAE := ManualActiveExpression
				on: [inputs]