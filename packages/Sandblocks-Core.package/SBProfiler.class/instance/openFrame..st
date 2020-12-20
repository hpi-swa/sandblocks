as yet unclassified
openFrame: aTally

	SBLabel text: ['todo: handle idle process properly'].
	self addMorphBack: (SBProfilerFrame new tally: aTally receivers second total: aTally receivers second tally totalTime: aTally time).
	self height: 0