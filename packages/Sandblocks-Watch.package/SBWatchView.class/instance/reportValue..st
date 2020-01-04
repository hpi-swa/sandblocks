as yet unclassified
reportValue: anObject

	hadValue ifFalse: [
		hadValue := true.
		self useDisplay: (self validDisplaysFor: anObject) first].

	(display class matches: anObject) ifFalse: [self useDisplay: SBDisplayPrint].
	
	lastValue := anObject.
	^ display reportValue: anObject