*Sandblocks-Core
firstSafeOptionFrom: aCollection
	" try to find the first representation that causes no side effects. If none were found assume, that the side effect was the user's intention "

	^ aCollection detect: [:repr | repr causesSideEffects not] ifNone: [aCollection first]