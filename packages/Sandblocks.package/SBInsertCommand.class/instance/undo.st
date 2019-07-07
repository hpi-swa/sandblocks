as yet unclassified
undo

	index := container submorphIndexOf: morph.
	container removeMorph: morph.
	^ (container hasSubmorphs and: [index notNil])
		ifTrue: [container submorphs at: (index clampLow: 1 high: container submorphCount)]
		ifFalse: [nil]