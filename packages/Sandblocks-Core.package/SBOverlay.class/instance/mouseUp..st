as yet unclassified
mouseUp: anEvent

	self delete.
	
	(activeMorph notNil and: [activeMorph command notNil]) ifTrue: [self sandblockEditor perform: activeMorph command]