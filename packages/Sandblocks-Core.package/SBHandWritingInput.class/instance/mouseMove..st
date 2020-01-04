as yet unclassified
mouseMove: anEvent

	recording ifFalse: [^ false].
	
	points add: anEvent position - self position.
	self changed