as yet unclassified
removedMorph: aMorph

	super removedMorph: aMorph.
	self hasSubmorphs ifFalse: [self extent: 0 @ 0]