as yet unclassified
bindings: aCollection

	self removeAllMorphs.
	
	aCollection ifNotEmpty: [
		self addMorphBack: (SBStringMorph new contents: '|').
		aCollection do: [:m | self addMorphBack: m].
		self addMorphBack: (SBStringMorph new contents: '|')]