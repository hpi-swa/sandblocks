compilation cue protocol
handleDroppedBlock: aBlock event: anEvent

	aBlock object
		representationThat: #isObject
		do: [:repr |
			(self createBinding: repr name asLegalSelector) binding value: repr]
		ifNone: [nil]