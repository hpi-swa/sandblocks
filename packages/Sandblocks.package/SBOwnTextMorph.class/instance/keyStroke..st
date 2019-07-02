as yet unclassified
keyStroke: anEvent

	| char |
	char := anEvent keyCharacter.
	
	char = Character arrowLeft ifTrue: [^ self moveCursorTo: self cursor - 1].
	char = Character arrowRight ifTrue: [^ self moveCursorTo: self cursor + 1].
	char = Character backspace ifTrue: [^ self deleteBeforeCursor].
	char = Character delete ifTrue: [^ self deleteAfterCursor].
	
	anEvent commandKeyPressed ifTrue: [
		char = $h ifTrue: [^ self moveCursorTo: self cursor - 1].
		char = $l ifTrue: [^ self moveCursorTo: self cursor + 1].
		char = $a ifTrue: [^ self moveCursorTo: 1].
		char = $e ifTrue: [^ self moveCursorTo: self contents size + 1]].
	
	self insertCharacter: char