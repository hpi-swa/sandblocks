as yet unclassified
reportValue: anObject

	hadValue ifFalse: [
		hadValue := true.
		self useDisplay: (self validDisplaysFor: anObject) first].
	
	(display class matches: anObject) ifFalse: [self useDisplay: SBDisplayPrint].
	
	count contents: (count contents asInteger + 1) asString.
	lastValue := anObject.
	^ display reportValue: anObject