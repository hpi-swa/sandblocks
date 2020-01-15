as yet unclassified
layoutMorphsOf: aMorph do: aBlock

	aMorph submorphs do: [:morph |
		morph disableLayout ifFalse: [aBlock value: morph]]