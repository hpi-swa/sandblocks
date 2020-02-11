as yet unclassified
body: aMorph

	body ifNotNil: [self removeMorph: aMorph].
	self addMorphBack: (body := aMorph)