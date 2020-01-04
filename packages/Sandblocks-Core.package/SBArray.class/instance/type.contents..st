as yet unclassified
type: aSymbol contents: aCollection

	type := aSymbol.
	
	self removeAllMorphs.
	aCollection do: [:m |
		self addMorphBack: m]