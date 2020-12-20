as yet unclassified
replaceWithUnknown

	| new |
	self isUnknown ifTrue: [^ self].
	
	self stopEditing.
	
	new := SBUnknown new.
	self replaceBy: new.
	new moveCursorTo: 0.
	new sandblockEditor replaceInput: new