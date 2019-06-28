as yet unclassified
binding: aBlock value: anotherBlock

	binding := aBlock.
	value  := anotherBlock.
	
	self addMorphBack: binding.
	self addMorphBack: (StringMorph new contents: ':=').
	self addMorphBack: value