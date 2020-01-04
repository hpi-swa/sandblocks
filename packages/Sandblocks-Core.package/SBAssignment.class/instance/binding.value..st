as yet unclassified
binding: aBlock value: anotherBlock

	self removeAllMorphs.
	self addMorphBack: aBlock.
	self addMorphBack: (SBStringMorph new contents: ':=').
	self addMorphBack: anotherBlock