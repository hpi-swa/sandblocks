as yet unclassified
promptChangeDisplay

	| choices index |
	choices := (SBWatchView watchTypes copyWithout: SBDisplayMultiple)" select: [:display |  isNil or: [display matches: lastValue]]".
	
	index := UIManager default chooseFrom: choices.
	index < 1 ifTrue: [^ self].
	
	self submorphs allButFirstDo: [:m| m delete].
	count timesRepeat: [self addMorphBack: ((choices at: index) new)]