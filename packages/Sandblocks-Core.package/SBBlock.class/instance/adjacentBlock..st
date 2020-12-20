hierarchy
adjacentBlock: aNumber

	| adjacent index |
	adjacent := (self parentSandblock ifNil: [^ nil]) childSandblocks.
	index := adjacent indexOf: self.
	^ adjacent at: index + aNumber ifAbsent: [nil]