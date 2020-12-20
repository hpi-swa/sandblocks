hierarchy
localNestingDepth

	^ 1 + (self parentSandblock ifNotNil: [:p | p localNestingDepth] ifNil: [0])