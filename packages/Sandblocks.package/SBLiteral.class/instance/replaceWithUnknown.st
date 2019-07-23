as yet unclassified
replaceWithUnknown

	| new |
	new := SBUnknown new.
	self replaceBy: new.
	
	text hasCursor ifTrue: [
		new moveCursorTo: 0.
		new sandblockEditor replaceInput: new]