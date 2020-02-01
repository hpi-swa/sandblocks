accessing
lastSideEffects: aCollection

	lastSideEffects := aCollection.
	aCollection ifNotEmpty: [sideEffectsIcon visible: true]