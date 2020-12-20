as yet unclassified
continueInputInArgument: anEvent

	self sandblockEditor startInput: (self adjacentBlock: 1) at: 0 replacingContents: false.
	^ self sandblockEditor selection keyStroke: anEvent