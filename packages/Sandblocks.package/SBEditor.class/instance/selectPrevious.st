selection
selectPrevious

	selectionDownHistory removeAll.
	self select: (self selection previousMorphThat: [:m | m isKindOf: SBBlock])