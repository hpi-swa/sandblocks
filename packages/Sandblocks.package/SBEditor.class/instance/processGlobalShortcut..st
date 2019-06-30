events
processGlobalShortcut: anEvent

	| char |
	char := anEvent keyCharacter.
	
	(char = $s and: [anEvent commandKeyPressed]) ifTrue: [self save. ^ true].
	(char = $r and: [anEvent commandKeyPressed]) ifTrue: [self redo. ^ true].
	char = $u ifTrue: [self undo. ^ true].
	
	anEvent commandKeyPressed ifTrue: [
		char = $s ifTrue: [self save. ^ true].
		char = $x ifTrue: [self promptSwitchMethodNewWindow: false. ^ true].
		char = $t ifTrue: [self promptSwitchMethodNewWindow: true. ^ true]].
	
	^ false