events
processGlobalShortcut: anEvent

	(anEvent commandKeyPressed and: [anEvent keyCharacter = $s]) ifTrue: [self save. ^ true].
	
	^ false