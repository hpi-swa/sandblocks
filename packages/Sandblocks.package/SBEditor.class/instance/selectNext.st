selection
selectNext

	selectionDownHistory removeAll.
	self select: (self selection nextMorphThat: [:m | m isKindOf: SBBlock])