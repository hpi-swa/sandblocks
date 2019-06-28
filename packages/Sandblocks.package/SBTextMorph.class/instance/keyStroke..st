as yet unclassified
keyStroke: anEvent

	" absorbed by keyDown: "
	anEvent keyCharacter = Character tab ifTrue: [^ self].
	
	^ super keyStroke: anEvent