as yet unclassified
removedMorph: aMorph

	super removedMorph: aMorph.
	
	self submorphCount < 1 ifTrue: [self extent: 0 @ 0]