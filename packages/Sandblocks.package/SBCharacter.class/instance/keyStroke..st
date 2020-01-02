as yet unclassified
keyStroke: anEvent

	"anEvent keyCharacter isAlphaNumeric"true
		ifTrue: [self contents: anEvent keyCharacter asString]
		ifFalse: [super keyStroke: anEvent]