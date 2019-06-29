as yet unclassified
binding: aBlock value: anotherBlock

	binding := aBlock.
	value  := anotherBlock.
	
	self addMorphBack: binding.
	self addMorphBack: (SBStringMorph new contents: ':=').
	self addMorphBack: value