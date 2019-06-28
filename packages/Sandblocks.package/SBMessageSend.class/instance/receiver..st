as yet unclassified
receiver: aBlock

	receiver ifNotNil: [self removeMorph: receiver].
	receiver := aBlock.
	self addMorph: receiver