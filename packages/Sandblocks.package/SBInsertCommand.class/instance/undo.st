as yet unclassified
undo

	index := container submorphIndexOf: morph.
	container removeMorph: morph.
	^ (container childSandblocks notEmpty and: [index notNil])
		ifTrue: [container childSandblocks at: (index clampLow: 1 high: container childSandblocks size)]
		ifFalse: [nil]