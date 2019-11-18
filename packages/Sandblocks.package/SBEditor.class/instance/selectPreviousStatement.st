selection
selectPreviousStatement

	selectionDownHistory removeAll.
	"next := self selection adjacentBlock: -1.
	next := next ifNil: [self selection parentSandblock].
	next ifNotNil: [:b | self select: b]"
	(self selection morphBeforeThat: #isStatement) ifNotNil: [:s | ^ self select: (s lastMorphThat: #isStatement)].
	"(self selection topFirstMorphThat: [:m | m isStatement and: [m ~= self selection]]) ifNotNil: [:s | ^ self select: s]."
	self select: ((self selection ownerSatisfying: #isStatement) ifNil: [self selection containingMethod])