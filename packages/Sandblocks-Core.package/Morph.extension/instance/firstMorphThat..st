*Sandblocks-Core
firstMorphThat: aBlock

	self allMorphsDoBreadthFirst: [:m | (aBlock value: m) ifTrue: [^ m]].
	^ nil