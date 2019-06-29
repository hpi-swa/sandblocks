as yet unclassified
keyStroke: anEvent

	" absorbed by keyDown: "
	anEvent keyCharacter = Character tab ifTrue: [^ self].
	anEvent keyCharacter = Character arrowUp ifTrue: [self selectUp. ^ self].
	
	^ super keyStroke: anEvent