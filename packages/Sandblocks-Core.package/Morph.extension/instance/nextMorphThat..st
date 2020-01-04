*Sandblocks-Core
nextMorphThat: aBlock

	^ (self nextAdjacentMorphThat: aBlock) ifNil: [self owner nextMorphThat: aBlock]