as yet unclassified
keyStroke: anEvent

	| char |
	char := anEvent keyCharacter.
	
	" absorbed by keyDown: "
	char = Character tab ifTrue: [^ self].
	
	char = Character arrowLeft ifTrue: [^ self moveCursorTo: self cursor - 1].
	char = Character arrowRight ifTrue: [^ self moveCursorTo: self cursor + 1].
	char = Character backspace ifTrue: [^ self deleteBeforeCursor].
	char = Character delete ifTrue: [^ self deleteAfterCursor].
	
	self insertCharacter: char