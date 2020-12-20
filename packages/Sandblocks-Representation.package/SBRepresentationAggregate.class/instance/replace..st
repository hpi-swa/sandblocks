as yet unclassified
replace: anObject

	self addMorph: (anObject anyRepresentationThat: #isToplevelMorph) asElementNumber: 3.
	count := count + 1.
	self count contents: count asString.
	[(self submorphCount - 2) > self limit] whileTrue: [self lastSubmorph delete]