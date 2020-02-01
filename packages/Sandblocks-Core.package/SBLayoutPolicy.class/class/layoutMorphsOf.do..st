as yet unclassified
layoutMorphsOf: aMorph do: aBlock

	aMorph submorphs do: [:morph |
		(morph disableLayout not and: [morph visible]) ifTrue: [aBlock value: morph]]