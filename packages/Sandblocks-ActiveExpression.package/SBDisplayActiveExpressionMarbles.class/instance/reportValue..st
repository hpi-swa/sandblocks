as yet unclassified
reportValue: anObject

	| subject |
	self flag: #fixme. " fragile "
	subject := thisContext sender sender sender sender receiver.
	
	anObject onChangeDo: [:newValue |  
		"newInvocation := SBActiveExpressionInvocation new
			stack: ((self relevantContextsFrom: thisContext) collect: [:context | SBCodeContext for: context]);
			addInvocation: newValue asString."
		
		self addMorphBack: (CircleMorph new
			extent: 10 asPoint withScalingFactor;
			color: subject sandblockColor;
			balloonText: newValue asString;
			on: #click send: #addHalo to: subject;
			yourself).
		
		"self submorphs
			detect: [:invocation | invocation sameLocation: newInvocation]
			ifFound: [:invocation | invocation addInvocation: newValue asString]
			ifNone: [
				self addMorphBack: newInvocation.
				self updateInterestingCodeLocations]"]