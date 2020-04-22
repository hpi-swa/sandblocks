compilation cue protocol
handleDroppedBlock: aBlock event: anEvent

	| name |
	name := aBlock name asLegalSelector.
	(self createBinding: name) binding value: aBlock evaluate