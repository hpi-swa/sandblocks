helper
addInvocation: anInvocation toList: aCollection

	aCollection addFirst: anInvocation.
	self updateInterestingCodeLocations: aCollection