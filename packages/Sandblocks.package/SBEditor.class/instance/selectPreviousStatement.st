selection
selectPreviousStatement

	| next |
	selectionDownHistory removeAll.
	next := (self selection adjacentBlock: -1).
	next := next ifNil: [self selection parentSandblock].
	next ifNotNil: [:b | self select: b]