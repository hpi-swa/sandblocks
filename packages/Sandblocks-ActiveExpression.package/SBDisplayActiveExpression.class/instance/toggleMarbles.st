as yet unclassified
toggleMarbles

	marbles owner
		ifNotNil: [marbles delete. self addMorphBack: invocations]
		ifNil: [invocations delete. self addMorphBack: marbles]