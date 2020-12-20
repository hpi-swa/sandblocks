hierarchy
childHierarchyComplexity

	^ self childSandblocks size < 2 ifTrue: [0] ifFalse: [ | c |
		c := 0.
		self allBlocksDo: [:b | c := c + 1].
		c]