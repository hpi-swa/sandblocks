events
processGlobalShortcut: anEvent

	| char |
	char := anEvent keyCharacter.
	
	char = $u ifTrue: [self undo. ^ true].
	char = $g ifTrue: [self select: self method. ^ true].
	
	anEvent commandKeyPressed ifTrue: [
		char = $l ifTrue: [self reset. ^ true].
		char = $r ifTrue: [self redo. ^ true].
		char = $s ifTrue: [self save. ^ true].
		char = $x ifTrue: [self promptSwitchMethodNewWindow: false. ^ true].
		char = $t ifTrue: [self promptSwitchMethodNewWindow: true. ^ true]].
	
	^ false