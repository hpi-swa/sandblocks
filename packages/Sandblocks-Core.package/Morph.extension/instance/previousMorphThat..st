*Sandblocks-Core
previousMorphThat: aBlock

	^ (self previousAdjacentMorphThat: aBlock) ifNil: [(self owner ifNil: [^ nil]) previousMorphThat: aBlock]