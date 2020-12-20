artefact protocol
setFromSource: aString

	self removeMorph: self lastSubmorph.
	self addMorphBack: aString parseAsSandblock