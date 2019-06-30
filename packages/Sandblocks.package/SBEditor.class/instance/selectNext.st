actions
selectNext

	self select: (self selection nextMorphThat: [:m | m isKindOf: SBBlock])