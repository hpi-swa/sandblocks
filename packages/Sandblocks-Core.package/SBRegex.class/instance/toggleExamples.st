as yet unclassified
toggleExamples

	examples owner
		ifNotNil: [examples delete]
		ifNil: [self addMorphBack: examples]