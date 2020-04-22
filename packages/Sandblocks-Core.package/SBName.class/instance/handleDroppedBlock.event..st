as yet unclassified
handleDroppedBlock: aBlock event: anEvent

	(self behavior handleDroppedBlock: aBlock event: anEvent) ifFalse: [super handleDroppedBlock: aBlock event: anEvent]