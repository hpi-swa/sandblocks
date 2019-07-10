as yet unclassified
expression: aBlock

	self submorphCount > 1 ifTrue: [self firstSubmorph delete].
	self addMorphFront: aBlock