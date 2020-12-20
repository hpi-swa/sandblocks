as yet unclassified
keyStroke: anEvent

	| char |
	char := anEvent keyCharacter.
	
	(anEvent keyCharacter = $v and: [anEvent commandKeyPressed]) ifTrue: [^ self insertString: Clipboard clipboardText].
	(anEvent keyCharacter = $c and: [anEvent commandKeyPressed]) ifTrue: [^ Clipboard clipboardText: self selection].
	char = Character arrowLeft ifTrue: [
		^ self moveCursor: -1 selecting: anEvent shiftPressed].
	char = Character arrowRight ifTrue: [
		^ self moveCursor: 1 selecting: anEvent shiftPressed].
	char = Character arrowUp ifTrue: [
		^ self moveCursorVertically: -1 selecting: anEvent shiftPressed].
	char = Character arrowDown ifTrue: [
		^ self moveCursorVertically: 1 selecting: anEvent shiftPressed].
	
	^ super keyStroke: anEvent