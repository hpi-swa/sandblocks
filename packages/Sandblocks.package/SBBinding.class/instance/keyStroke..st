as yet unclassified
keyStroke: anEvent

	super keyStroke: anEvent.
	
	self isReserved ifTrue: [^ self assureClass: SBKeywordBinding].
	
	self updateSuggestions