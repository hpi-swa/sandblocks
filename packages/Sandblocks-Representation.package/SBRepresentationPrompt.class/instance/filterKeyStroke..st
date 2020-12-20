as yet unclassified
filterKeyStroke: anEvent

	anEvent keyCharacter = Character cr ifTrue: [self close].
	anEvent keyCharacter = Character arrowDown ifTrue: [self select: selectedIndex + 1].
	anEvent keyCharacter = Character arrowUp ifTrue: [self select: selectedIndex - 1]