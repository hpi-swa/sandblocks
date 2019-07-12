as yet unclassified
keyStroke: anEvent

	super keyStroke: anEvent.
	
	anEvent keyCharacter = $: ifTrue: [^ self sandblockEditor do: (SBWrapCommand new
		inner: self;
		outer: SBAssignment new;
		wrap: [:outer :inner | outer binding: self value: SBUnknown new])].
	
	self isReserved ifTrue: [^ self assureClass: SBKeywordBinding].
	
	self updateSuggestions