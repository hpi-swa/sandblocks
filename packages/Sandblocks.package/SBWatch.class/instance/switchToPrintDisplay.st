as yet unclassified
switchToPrintDisplay

	self submorphCount > 1 ifTrue: [self submorphs second delete].
	
	self addMorphBack: (display := SBStringMorph new color: Color white; contents: '...')