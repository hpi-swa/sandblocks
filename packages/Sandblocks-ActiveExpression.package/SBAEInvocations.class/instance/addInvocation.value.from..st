as yet unclassified
addInvocation: aContext value: anObject from: aSubjectObject

	| newInvocation stack |
	stack := (self relevantContextsFrom: thisContext).
	
	Project current addDeferredUIMessage: [
		newInvocation := SBActiveExpressionInvocation new
			 stack: stack;
			 addInvocation: anObject asString;
			 subject: aSubjectObject.
		
		self submorphs
			detect: [:invocation | invocation sameLocation: newInvocation]
			ifFound: [:invocation | invocation addInvocation: anObject asString]
			ifNone: [
				self addMorphBack: newInvocation.
				self updateInterestingCodeLocations]]