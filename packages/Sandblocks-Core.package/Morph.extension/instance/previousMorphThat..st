*Sandblocks-Core
previousMorphThat: aBlock

	^ (self previousAdjacentMorphThat: aBlock) ifNil: [self owner previousMorphThat: aBlock]