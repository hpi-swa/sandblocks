as yet unclassified
undo

	| parentBlock |
	index := container submorphIndexOf: morph.
	container removeMorph: morph.
	
	parentBlock := container containingSandblock.
	^ (parentBlock childSandblocks notEmpty and: [index notNil])
		ifTrue: [parentBlock childSandblocks at: (index clampLow: 1 high: parentBlock childSandblocks size)]
		ifFalse: [nil]