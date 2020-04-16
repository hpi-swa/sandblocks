*Sandblocks-Core
nextMorphThat: aBlock

	^ (self nextAdjacentMorphThat: aBlock) ifNil: [(self owner ifNil: [^ nil]) nextMorphThat: aBlock]