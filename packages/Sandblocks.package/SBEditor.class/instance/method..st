as yet unclassified
method: aMethodBlock

	self okToChange ifFalse: [^ self].
	
	self method isSandblock ifTrue: [self method delete].
	
	self addMorphFront: aMethodBlock.
	self resetState.
	self changed: #relabel