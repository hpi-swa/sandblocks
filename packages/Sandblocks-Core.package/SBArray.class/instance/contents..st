as yet unclassified
contents: aCollection

	self removeAllMorphs.
	aCollection do: [:m |
		self addMorphBack: m]