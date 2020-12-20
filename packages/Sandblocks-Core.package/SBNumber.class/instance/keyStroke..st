as yet unclassified
keyStroke: anEvent

	(anEvent keyCharacter = $- and: [text isCursorAtStart]) ifTrue: [^ self acceptInputEvent: anEvent].
	
	super keyStroke: anEvent.
	
	self contents: (self contents select: [:char | char isAlphaNumeric or: [char = $- or: [char = $.]]])