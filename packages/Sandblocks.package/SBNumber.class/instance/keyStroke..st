as yet unclassified
keyStroke: anEvent

	(anEvent keyCharacter = $- and: [text isCursorAtStart]) ifTrue: [
		text keyStroke: anEvent.
		^ self].
	super keyStroke: anEvent