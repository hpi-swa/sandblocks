as yet unclassified
parentWasReached: aBlock

	| block |
	block := aBlock.
	[block notNil and: [block isLiteralBlock or: [block isName or: [block isBlockBody or: [block isCascade and: [self wasReached: block messages first]]]]]] whileTrue: [
		block := block parentSandblock].
	^ block notNil and: [self wasReached: block]