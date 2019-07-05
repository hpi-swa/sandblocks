events
processGlobalShortcut: anEvent

	| char |
	char := anEvent keyCharacter.
	
	char = $u ifTrue: [self undo. ^ true].
	char = $U ifTrue: [self redo. ^ true].
	char = $g ifTrue: [self select: self method. ^ true].
	
	anEvent commandKeyPressed ifTrue: [
		char = $y ifTrue: [self promptChangeClass. ^ true].
		char = $l ifTrue: [self reset. ^ true].
		char = $s ifTrue: [self save. ^ true].
		char = $x ifTrue: [self promptSwitchMethodNewWindow: false. ^ true].
		char = $t ifTrue: [self promptSwitchMethodNewWindow: true. ^ true]].
	
	shortcuts do: [:pair | (pair first value: anEvent) ifTrue: [pair second value. ^ true]].
	
	^ false