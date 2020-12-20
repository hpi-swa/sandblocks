as yet unclassified
statements: aCollection

	self submorphs allButFirst do: [:m | self removeMorph: m].
	aCollection do: [:m | self addMorphBack: m]