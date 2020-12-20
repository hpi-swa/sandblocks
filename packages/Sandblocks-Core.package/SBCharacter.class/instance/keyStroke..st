as yet unclassified
keyStroke: anEvent

	anEvent keyCharacter = Character backspace ifTrue: [
		^ self replaceWithUnknown].

	(anEvent keyCharacter shouldBePrintedAsLiteral or: [anEvent keyCharacter = Character space])
		ifTrue: [self contents: anEvent keyCharacter asString]
		ifFalse: [super keyStroke: anEvent]