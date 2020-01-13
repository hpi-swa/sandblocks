as yet unclassified
updateTickDividers

	| tickTime |
	tickTime := WorldState lastCycleTime.
	(lastTickTime ~= tickTime and: [self hasSubmorphs])
		ifTrue: [
			self addMorphBack: (Morph new
				 color: Color lightGray;
				 extent: 2 @ self marbleSize y;
				 yourself)].
	lastTickTime := tickTime