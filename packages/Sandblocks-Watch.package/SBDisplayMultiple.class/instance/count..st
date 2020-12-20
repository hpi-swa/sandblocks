as yet unclassified
count: aNumber

	count := aNumber.
	countInput value: aNumber.
	
	self submorphs allButFirstDo: [:morph | self removeMorph: morph].
	count timesRepeat: [self addMorphBack: SBDisplayPrint new]