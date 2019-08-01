as yet unclassified
mouseUp: anEvent

	self delete.
	
	activeMorph ifNotNil: [self sandblockEditor perform: activeMorph command]