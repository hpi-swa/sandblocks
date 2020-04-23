as yet unclassified
updateExplorers

	explorer ifNotNil: #delete.
	self addMorphBack: (explorer := SBExplorer on: self currentStackFrame context receiver) toggleCollapsed