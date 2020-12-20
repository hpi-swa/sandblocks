artefact protocol
typeFor: aBlock

	^ self typeCache at: aBlock ifAbsent: [nil]