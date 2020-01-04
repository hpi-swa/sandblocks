*Sandblocks-Core
topFirstMorphThat: aBlock

	self allMorphsDoBreadthFirst: [:m | (aBlock value: m) ifTrue: [^ m]].
	^ nil