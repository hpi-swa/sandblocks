*Sandblocks
firstMorphThat: aBlock

	self allMorphsDo: [:m | (aBlock value: m) ifTrue: [^ m]].
	^ nil