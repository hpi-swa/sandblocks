actions
selectPrevious

	self select: (self selection previousMorphThat: [:m | m isKindOf: SBBlock])