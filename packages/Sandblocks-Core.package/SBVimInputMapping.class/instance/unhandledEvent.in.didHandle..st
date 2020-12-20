as yet unclassified
unhandledEvent: anEvent in: anEditor didHandle: aBlock

	anEvent keyCharacter isDigit ifTrue: [
		countModifier := countModifier, anEvent keyCharacter.
		^ aBlock value]