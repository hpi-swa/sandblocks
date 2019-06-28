as yet unclassified
bindings: aCollection

	self removeAllMorphs.
	aCollection do: [:m | self addMorphBack: m]