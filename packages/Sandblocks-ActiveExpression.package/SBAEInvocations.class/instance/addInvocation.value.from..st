as yet unclassified
addInvocation: aContext value: anObject from: aSubjectObject

	| newInvocation |
	newInvocation := SBActiveExpressionInvocation new
		 stack: (self relevantContextsFrom: thisContext);
		 addInvocation: anObject asString;
		 subject: aSubjectObject.
	self submorphs
		detect: [:invocation | invocation sameLocation: newInvocation]
		ifFound: [:invocation | invocation addInvocation: anObject asString]
		ifNone: [
			self addMorphBack: newInvocation.
			self updateInterestingCodeLocations]