as yet unclassified
method: aMethodBlock

	self method isSandblock ifTrue: [self method delete].
	
	self addMorphFront: aMethodBlock.
	self resetState