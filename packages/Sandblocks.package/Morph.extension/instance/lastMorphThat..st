*Sandblocks
lastMorphThat: aBlock

	self reverseAllMorphsDo: [:m | (aBlock value: m) ifTrue: [^ m]].
	^ nil