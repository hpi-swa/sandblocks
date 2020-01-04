as yet unclassified
receiver: aBlock

	self submorphCount > 1 ifTrue: [self firstSubmorph delete].
	aBlock ifNotNil: [self addMorph: aBlock]