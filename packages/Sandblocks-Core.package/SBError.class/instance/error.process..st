as yet unclassified
error: anError process: aProcess

	error := anError.
	process := aProcess.
	self addMorphFront: (SBRow new
		addMorphBack: (SBIcon iconFlash color: Color red);
		addMorphBack: (SBStringMorph new bold; contents: (anError asString truncateMiddleTo: 30));
		yourself)