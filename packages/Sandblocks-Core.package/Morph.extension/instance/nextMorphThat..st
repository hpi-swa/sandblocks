*Sandblocks-Core
nextMorphThat: aBlock

	(self firstMorphThat: aBlock) ifNotNil: [:b | ^ b].
	(self nextAdjacentMorphThat: aBlock) ifNotNil: [:b | ^ b].
	^ (self owner ifNil: [^ nil]) nextMorphThat: aBlock