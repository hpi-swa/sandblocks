callbacks
updateTickDividers

	| tickTime |
	tickTime := WorldState lastCycleTime.
	(lastTickTime ~= tickTime and: [self hasSubmorphs])
		ifTrue: [
			self addMorphBack: (Morph new
				 color: Color lightGray;
				 extent: 2 @ SBMarble marbleSize y;
				 yourself)].
	lastTickTime := tickTime